// lib/data/services/sync_queue_dispatcher.dart
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../models/sync_envelope_dto.dart';

class SyncDispatchResult {
  final int totalDispatched;
  final int rawBytes;
  final int compressedBytes;
  final double compressionRatio;
  final bool isSuccess;
  final String? errorMessage;

  const SyncDispatchResult({
    required this.totalDispatched,
    required this.rawBytes,
    required this.compressedBytes,
    required this.compressionRatio,
    required this.isSuccess,
    this.errorMessage,
  });

  factory SyncDispatchResult.empty() => const SyncDispatchResult(
        totalDispatched: 0,
        rawBytes: 0,
        compressedBytes: 0,
        compressionRatio: 0.0,
        isSuccess: true,
      );

  factory SyncDispatchResult.failure(String message, {int count = 0}) =>
      SyncDispatchResult(
        totalDispatched: count,
        rawBytes: 0,
        compressedBytes: 0,
        compressionRatio: 0.0,
        isSuccess: false,
        errorMessage: message,
      );
}

class SyncQueueDispatcher {
  static const String defaultEndpoint = 'https://api.pintig.health/api/v1/sync/batch';
  static const String tenantId = 'ph_biliran_naval';
  static const String barangayId = 'brgy_pi_garcia';
  static const String clientVersion = '1.0.0+1';
  static const int maxBatchLimit = 100;
  static const int maxRetryThreshold = 5;

  final AppDatabase db;
  final http.Client httpClient;
  final String deviceId;
  final String endpointUrl;
  final Uuid _uuid = const Uuid();

  SyncQueueDispatcher({
    required this.db,
    http.Client? client,
    required this.deviceId,
    this.endpointUrl = defaultEndpoint,
  }) : httpClient = client ?? http.Client();

  Future<SyncDispatchResult> dispatchPendingQueue() async {
    // 1. Fetch pending records up to batch ceiling
    final pendingRecords = await (db.select(db.syncQueue)
          ..where((tbl) => tbl.syncStatus.equals('PENDING'))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
          ..limit(maxBatchLimit))
        .get();

    if (pendingRecords.isEmpty) {
      return SyncDispatchResult.empty();
    }

    final recordIds = pendingRecords.map((r) => r.queueId).toList();

    // 2. Atomically transition records to IN_FLIGHT
    await (db.update(db.syncQueue)..where((tbl) => tbl.queueId.isIn(recordIds))).write(
      const SyncQueueCompanion(
        syncStatus: Value('IN_FLIGHT'),
      ),
    );

    // 3. Construct canonical SyncPayloadEnvelopeDto
    final List<DemographicMutationDto> demographics = [];
    final List<ClinicalEncounterDto> encounters = [];

    for (final row in pendingRecords) {
      final decodedJson = jsonDecode(row.payloadJson) as Map<String, dynamic>;

      if (row.entityType == 'ENCOUNTER') {
        encounters.add(ClinicalEncounterDto.fromJson(decodedJson));
      } else if (row.entityType == 'HOUSEHOLD' || row.entityType == 'PATIENT') {
        demographics.add(DemographicMutationDto.fromJson(decodedJson));
      }
    }

    final envelope = SyncPayloadEnvelopeDto(
      syncBatchId: _uuid.v4(),
      deviceId: deviceId,
      tenantId: tenantId,
      barangayId: barangayId,
      clientVersion: clientVersion,
      dispatchedAt: DateTime.now().toUtc().toIso8601String(),
      payloadCount: demographics.length + encounters.length,
      demographicMutations: demographics,
      clinicalEncounters: encounters,
    );

    // 4. Serialize & Gzip Compress Payload
    final rawJsonString = jsonEncode(envelope.toJson());
    final rawBytes = utf8.encode(rawJsonString);
    final compressedBytes = gzip.encode(rawBytes);

    final compressionRatio = 1.0 - (compressedBytes.length / (rawBytes.isEmpty ? 1 : rawBytes.length));

    // 5. Dispatch via HTTPS POST
    try {
      final response = await httpClient.post(
        Uri.parse(endpointUrl),
        headers: {
          'Content-Type': 'application/json',
          'Content-Encoding': 'gzip',
          'Accept-Encoding': 'gzip',
          'X-Pintig-Device-ID': deviceId,
          'X-Pintig-Tenant-ID': tenantId,
          'X-Pintig-Barangay-ID': barangayId,
        },
        body: compressedBytes,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // 6. On HTTP 200 OK: Mark SYNCED and stamp synced_at (triggers 90-day retention prune)
        final nowIso = DateTime.now().toUtc().toIso8601String();
        await db.transaction(() async {
          for (final id in recordIds) {
            await (db.update(db.syncQueue)..where((tbl) => tbl.queueId.equals(id))).write(
              SyncQueueCompanion(
                syncStatus: const Value('SYNCED'),
                syncedAt: Value(nowIso),
              ),
            );
          }
        });

        return SyncDispatchResult(
          totalDispatched: envelope.payloadCount,
          rawBytes: rawBytes.length,
          compressedBytes: compressedBytes.length,
          compressionRatio: (compressionRatio * 100).roundToDouble() / 100,
          isSuccess: true,
        );
      } else {
        await _rollbackInFlightRecords(
          recordIds,
          'Server rejected payload with status code ${response.statusCode}',
        );
        return SyncDispatchResult.failure(
          'HTTP ${response.statusCode}: ${response.body}',
          count: envelope.payloadCount,
        );
      }
    } catch (e) {
      await _rollbackInFlightRecords(recordIds, e.toString());
      return SyncDispatchResult.failure(
        'Transport failure: ${e.toString()}',
        count: envelope.payloadCount,
      );
    }
  }

  Future<void> _rollbackInFlightRecords(List<int> recordIds, String reason) async {
    await db.transaction(() async {
      for (final id in recordIds) {
        final existing = await (db.select(db.syncQueue)..where((tbl) => tbl.queueId.equals(id)))
            .getSingleOrNull();

        if (existing != null) {
          final nextRetry = existing.retryCount + 1;
          final nextStatus = nextRetry >= maxRetryThreshold ? 'FAILED' : 'PENDING';

          await (db.update(db.syncQueue)..where((tbl) => tbl.queueId.equals(id))).write(
            SyncQueueCompanion(
              syncStatus: Value(nextStatus),
              retryCount: Value(nextRetry),
            ),
          );
        }
      }
    });
  }
}