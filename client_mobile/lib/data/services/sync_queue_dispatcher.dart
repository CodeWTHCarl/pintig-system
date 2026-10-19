import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../local/database.dart';

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
          final encounterType = (encMap['encounter_type'] ?? encMap['encounterType'] ?? 'MATERNAL_CARE').toString().toUpperCase();
          final timestamp = (encMap['timestamp'] ?? DateTime.now().toUtc().toIso8601String()) as String;
          final triageRiskLevel = (encMap['triage_risk_level'] ?? encMap['risk_level'] ?? 'NORMAL').toString().toUpperCase();

          final clinicalDataRaw = encMap['clinical_data'] ?? encMap['clinicalData'] ?? {};
          final clinicalDataMap = clinicalDataRaw is Map
              ? Map<String, dynamic>.from(clinicalDataRaw)
              : <String, dynamic>{};

          // 1. Write raw encounter document to Firestore
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

          // 2. Write dynamic triage alert if risk is HIGH or MODERATE
          if (triageRiskLevel == 'HIGH' || triageRiskLevel == 'MODERATE') {
            final summaryText = _buildClinicalSummary(
              encounterType: encounterType,
              riskLevel: triageRiskLevel,
              clinicalData: clinicalDataMap,
            );

            final alertFields = {
              'alert_uuid': encounterUuid,
              'encounter_uuid': encounterUuid,
              'patient_uuid': patientUuid,
              'bhw_id': bhwId,
              'encounter_type': encounterType,
              'risk_level': triageRiskLevel,
              'status': 'PENDING',
              'clinical_summary': summaryText,
              'triggered_at': timestamp,
            };

            await _patchDocument(
              client: client,
              collectionPath: 'triage_alerts',
              documentId: encounterUuid,
              fields: alertFields,
            );
          }

          // 3. Atomically increment monthly KPI aggregates on Firestore
          final yearMonth = timestamp.length >= 7 ? timestamp.substring(0, 7) : '2026-10';
          await _incrementMonthlyAggregates(
            client: client,
            yearMonth: yearMonth,
            encounterType: encounterType,
            riskLevel: triageRiskLevel,
          );

          dispatchedCount++;
        }
      }

      // 4. Mark all pending rows as SYNCED and notify Drift stream
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

  /// Builds module-specific clinical summaries for the Web Triage Feed.
  String _buildClinicalSummary({
    required String encounterType,
    required String riskLevel,
    required Map<String, dynamic> clinicalData,
  }) {
    final patientPrefix = clinicalData['patient_name'] != null
        ? '${clinicalData['patient_name']} • '
        : '';

    if (encounterType.contains('MATERNAL')) {
      final sys = clinicalData['systolic_bp'] ?? 'N/A';
      final dia = clinicalData['diastolic_bp'] ?? 'N/A';
      return '${patientPrefix}Maternal Care: BP $sys/$dia mmHg (Preeclampsia Risk - $riskLevel)';
    } else if (encounterType.contains('NUTRITION') || encounterType.contains('OPT')) {
      final weight = clinicalData['weight_kg'] ?? clinicalData['weight'] ?? 'N/A';
      final height = clinicalData['height_cm'] ?? clinicalData['length_cm'] ?? 'N/A';
      final whz = clinicalData['whz'] ?? clinicalData['wfl_z_score'] ?? '';
      final status = clinicalData['nutritional_status'] ?? 'SAM';
      final zText = whz.toString().isNotEmpty ? ' | WHZ: $whz ($status)' : ' ($status)';
      return '${patientPrefix}OPT+ Nutrition: Wt ${weight}kg, Ht ${height}cm$zText';
    } else if (encounterType.contains('IMMUNIZATION') || encounterType.contains('EPI')) {
      final vaccine = clinicalData['antigen_code'] ?? clinicalData['vaccine_code'] ?? 'EPI Vaccine';
      final dose = clinicalData['dose_number'] ?? '1';
      final notes = clinicalData['aefi_notes'] != null ? ' - ${clinicalData['aefi_notes']}' : '';
      return '${patientPrefix}AEFI Alert: $vaccine (Dose $dose)$notes';
    }
    return '$patientPrefix$encounterType Encounter (CDSS Flagged $riskLevel)';
  }

  /// Atomically increments monthly KPI counters in aggregates/{yearMonth}.
  Future<void> _incrementMonthlyAggregates({
    required HttpClient client,
    required String yearMonth,
    required String encounterType,
    required String riskLevel,
  }) async {
    try {
      final commitUrl = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents:commit?key=$apiKey',
      );

      final docPath =
          'projects/$projectId/databases/(default)/documents/tenants/$tenantId/barangays/$barangayId/aggregates/$yearMonth';

      final List<Map<String, dynamic>> fieldTransforms = [
        {
          'fieldPath': 'total_encounters',
          'increment': {'integerValue': '1'}
        },
      ];

      if (encounterType.contains('MATERNAL')) {
        fieldTransforms.add({
          'fieldPath': 'maternal_care_count',
          'increment': {'integerValue': '1'}
        });
        fieldTransforms.add({
          'fieldPath': 'maternal_encounters',
          'increment': {'integerValue': '1'}
        });
        if (riskLevel == 'HIGH' || riskLevel == 'MODERATE') {
          fieldTransforms.add({
            'fieldPath': 'high_risk_maternal_count',
            'increment': {'integerValue': '1'}
          });
          fieldTransforms.add({
            'fieldPath': 'high_risk_maternal',
            'increment': {'integerValue': '1'}
          });
        }
      } else if (encounterType.contains('NUTRITION') || encounterType.contains('OPT')) {
        fieldTransforms.add({
          'fieldPath': 'nutrition_opt_count',
          'increment': {'integerValue': '1'}
        });
        fieldTransforms.add({
          'fieldPath': 'opt_encounters',
          'increment': {'integerValue': '1'}
        });
        if (riskLevel == 'HIGH' || riskLevel == 'MODERATE') {
          fieldTransforms.add({
            'fieldPath': 'severe_wasting_count',
            'increment': {'integerValue': '1'}
          });
          fieldTransforms.add({
            'fieldPath': 'high_risk_nutrition_count',
            'increment': {'integerValue': '1'}
          });
        }
      } else if (encounterType.contains('IMMUNIZATION') || encounterType.contains('EPI')) {
        fieldTransforms.add({
          'fieldPath': 'immunization_count',
          'increment': {'integerValue': '1'}
        });
        fieldTransforms.add({
          'fieldPath': 'immunization_encounters',
          'increment': {'integerValue': '1'}
        });
        fieldTransforms.add({
          'fieldPath': 'fic_count',
          'increment': {'integerValue': '1'}
        });
      }

      if (riskLevel == 'HIGH' || riskLevel == 'MODERATE') {
        fieldTransforms.add({
          'fieldPath': 'active_triage_alerts',
          'increment': {'integerValue': '1'}
        });
      }

      final payload = {
        'writes': [
          {
            'transform': {
              'document': docPath,
              'fieldTransforms': fieldTransforms,
            }
          }
        ]
      };

      final request = await client.postUrl(commitUrl);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(payload));
      final response = await request.close();
      await utf8.decoder.bind(response).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('[PINTIG AGGREGATES OK] Incremented KPIs for $yearMonth');
      }
    } catch (e) {
      debugPrint('[PINTIG AGGREGATES WARN] Failed to increment KPIs: $e');
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