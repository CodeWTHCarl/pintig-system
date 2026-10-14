import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../local/database.dart';
import '../models/sync_envelope_dto.dart';

class SyncDispatchResult {
  final bool isSuccess;
  final int recordsDispatched;
  final double compressionRatio;
  final int latencyMs;
  final String? errorMessage;

  const SyncDispatchResult({
    required this.isSuccess,
    this.recordsDispatched = 0,
    this.compressionRatio = 1.0,
    this.latencyMs = 0,
    this.errorMessage,
  });
}

class SyncQueueDispatcher {
  final AppDatabase db;
  final String deviceId;
  final String tenantId;
  final String barangayId;
  final String projectId;
  final String apiKey;

  SyncQueueDispatcher({
    required this.db,
    required this.deviceId,
    this.tenantId = 'ph_biliran_naval',
    this.barangayId = 'brgy_pi_garcia',
    this.projectId = 'pintig-219',
    this.apiKey = 'AIzaSyD-8cINNdnwGzmunFDYvLvCNuqrCyqGmvA',
  });

  Future<SyncDispatchResult> dispatchPendingQueue() async {
    final client = HttpClient();
    final stopwatch = Stopwatch()..start();
    int dispatchedCount = 0;

    try {
      final pendingRows = await db.customSelect(
        "SELECT rowid AS _sqlite_rowid, * FROM sync_queue WHERE sync_status = 'PENDING' ORDER BY created_at ASC",
      ).get();

      if (pendingRows.isEmpty) {
        stopwatch.stop();
        debugPrint('[PINTIG SYNC] Queue is empty. 0 pending records.');
        return const SyncDispatchResult(
          isSuccess: true,
          recordsDispatched: 0,
          compressionRatio: 1.0,
          latencyMs: 0,
        );
      }

      debugPrint('[PINTIG SYNC] Found ${pendingRows.length} pending record(s). Processing dispatch...');

      for (final row in pendingRows) {
        final data = row.data;

        final rawPayload = data['payload_json'] ??
            data['payload'] ??
            data['envelope_json'];

        if (rawPayload == null) {
          debugPrint('[PINTIG SYNC WARN] Skipping row with null payload.');
          continue;
        }

        final Map<String, dynamic> decoded = rawPayload is String
            ? jsonDecode(rawPayload) as Map<String, dynamic>
            : Map<String, dynamic>.from(rawPayload as Map);

        List<Map<String, dynamic>> encountersToPush = [];

        if (decoded.containsKey('clinical_encounters') &&
            decoded['clinical_encounters'] is List) {
          for (final item in decoded['clinical_encounters'] as List) {
            encountersToPush.add(Map<String, dynamic>.from(item as Map));
          }
        } else {
          encountersToPush.add(decoded);
        }

        for (final encMap in encountersToPush) {
          final encounterUuid = (encMap['encounter_uuid'] ??
              encMap['encounterUuid'] ??
              encMap['id'] ??
              'enc-${DateTime.now().millisecondsSinceEpoch}') as String;

          final patientUuid = (encMap['patient_uuid'] ??
              encMap['patientUuid'] ??
              'unknown-patient') as String;

          final bhwId = (encMap['bhw_id'] ?? encMap['bhwId'] ?? 'BHW-NAV-01') as String;
          final encounterType = (encMap['encounter_type'] ?? encMap['encounterType'] ?? 'MATERNAL_CARE') as String;
          final timestamp = (encMap['timestamp'] ?? DateTime.now().toUtc().toIso8601String()) as String;
          final triageRiskLevel = (encMap['triage_risk_level'] ?? encMap['risk_level'] ?? 'NORMAL').toString().toUpperCase();

          final clinicalDataRaw = encMap['clinical_data'] ?? encMap['clinicalData'] ?? {};
          final clinicalDataMap = clinicalDataRaw is Map
              ? Map<String, dynamic>.from(clinicalDataRaw)
              : <String, dynamic>{};

          // 1. Write encounter document to Firestore
          final encounterFields = {
            'encounter_uuid': encounterUuid,
            'patient_uuid': patientUuid,
            'bhw_id': bhwId,
            'encounter_type': encounterType,
            'timestamp': timestamp,
            'triage_risk_level': triageRiskLevel,
            'clinical_data': jsonEncode(clinicalDataMap),
            'device_id': deviceId,
            'synced_at': DateTime.now().toUtc().toIso8601String(),
          };

          final encounterOk = await _patchDocument(
            client: client,
            collectionPath: 'encounters',
            documentId: encounterUuid,
            fields: encounterFields,
          );

          if (!encounterOk) {
            throw HttpException('Firestore rejected encounter $encounterUuid');
          }

          // 2. Write triage alert document if risk is elevated
          if (triageRiskLevel == 'HIGH' || triageRiskLevel == 'MODERATE') {
            final systolic = clinicalDataMap['systolic_bp'] ?? 'N/A';
            final diastolic = clinicalDataMap['diastolic_bp'] ?? 'N/A';

            final alertFields = {
              'alert_uuid': encounterUuid,
              'encounter_uuid': encounterUuid,
              'patient_uuid': patientUuid,
              'bhw_id': bhwId,
              'encounter_type': encounterType,
              'risk_level': triageRiskLevel,
              'status': 'PENDING',
              'clinical_summary': 'Blood Pressure: $systolic/$diastolic mmHg (CDSS Flagged $triageRiskLevel)',
              'triggered_at': timestamp,
            };

            await _patchDocument(
              client: client,
              collectionPath: 'triage_alerts',
              documentId: encounterUuid,
              fields: alertFields,
            );
          }

          dispatchedCount++;
        }
      }

      // 3. Mark all pending rows as SYNCED and notify Drift reactive stream
      final syncTable = db.allTables.cast<TableInfo?>().firstWhere(
        (t) => t?.actualTableName == 'sync_queue',
        orElse: () => null,
      );

      await db.customUpdate(
        "UPDATE sync_queue SET sync_status = 'SYNCED' WHERE sync_status = 'PENDING'",
        updates: syncTable != null ? {syncTable} : {},
      );

      stopwatch.stop();
      debugPrint('[PINTIG SYNC] Successfully synced $dispatchedCount record(s) to Firestore.');
      return SyncDispatchResult(
        isSuccess: true,
        recordsDispatched: dispatchedCount,
        compressionRatio: 1.0,
        latencyMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      stopwatch.stop();
      debugPrint('[PINTIG SYNC ERROR] Push failed: $e');
      return SyncDispatchResult(
        isSuccess: false,
        recordsDispatched: dispatchedCount,
        errorMessage: e.toString(),
        compressionRatio: 1.0,
        latencyMs: stopwatch.elapsedMilliseconds,
      );
    } finally {
      client.close();
    }
  }

  Future<bool> _patchDocument({
    required HttpClient client,
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> fields,
  }) async {
    try {
      final maskParams = fields.keys.map((k) => 'updateMask.fieldPaths=$k').join('&');
      final urlStr =
          'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/tenants/$tenantId/barangays/$barangayId/$collectionPath/$documentId?$maskParams&key=$apiKey';

      final request = await client.patchUrl(Uri.parse(urlStr));
      request.headers.contentType = ContentType.json;

      final body = {
        'fields': _encodeFirestoreFields(fields),
      };

      request.write(jsonEncode(body));
      final response = await request.close();
      final responseBody = await utf8.decoder.bind(response).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('[PINTIG FIRESTORE OK] Written to $collectionPath/$documentId');
        return true;
      } else {
        debugPrint('[PINTIG FIRESTORE ERROR ${response.statusCode}] $responseBody');
        return false;
      }
    } catch (e) {
      debugPrint('[PINTIG HTTP ERROR] $e');
      return false;
    }
  }

  Map<String, dynamic> _encodeFirestoreFields(Map<String, dynamic> raw) {
    final fields = <String, dynamic>{};
    raw.forEach((key, val) {
      if (val == null) {
        fields[key] = {'nullValue': null};
      } else if (val is String) {
        fields[key] = {'stringValue': val};
      } else if (val is int) {
        fields[key] = {'integerValue': val.toString()};
      } else if (val is double) {
        fields[key] = {'doubleValue': val};
      } else if (val is bool) {
        fields[key] = {'booleanValue': val};
      } else {
        fields[key] = {'stringValue': val.toString()};
      }
    });
    return fields;
  }
}