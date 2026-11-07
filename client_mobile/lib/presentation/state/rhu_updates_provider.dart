// lib/presentation/state/rhu_updates_provider.dart
//
// Read-only: fetches the triage alerts this BHW sent and returns the ones the
// RHU has already acted on, so the BHW can see the loop close. Offline or on
// any error it returns an empty list and the home screen simply shows nothing.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Same project values as SyncQueueDispatcher. Move both to one config file.
const String _projectId = 'pintig-219';
const String _apiKey = 'AIzaSyD-8cINNdnwGzmunFDYvLvCNuqrCyqGmvA';
const String _tenantId = 'ph_biliran_naval';
const String _barangayId = 'brgy_pi_garcia';
const String _bhwId = 'BHW-NAV-01';

class RhuUpdate {
  final String alertUuid;
  final String patientName;
  final String sitioPurok;
  final String status; // ACKNOWLEDGED | REFERRED | RESOLVED
  final String notes;
  final DateTime? actedAt;

  const RhuUpdate({
    required this.alertUuid,
    required this.patientName,
    required this.sitioPurok,
    required this.status,
    required this.notes,
    required this.actedAt,
  });

  String get statusLabel {
    switch (status) {
      case 'REFERRED':
        return 'Referred to Biliran Provincial Hospital';
      case 'RESOLVED':
        return 'Closed by the RHU';
      default:
        return 'Seen by the RHU';
    }
  }
}

String _str(Map<String, dynamic> fields, String key) {
  final v = fields[key];
  if (v is Map && v['stringValue'] is String) return v['stringValue'] as String;
  return '';
}

DateTime? _time(Map<String, dynamic> fields, String key) {
  final v = fields[key];
  if (v is Map) {
    final raw = v['timestampValue'] ?? v['stringValue'];
    if (raw is String) return DateTime.tryParse(raw)?.toLocal();
  }
  return null;
}

Future<List<RhuUpdate>> fetchRhuUpdates() async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 6);
  try {
    final uri = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents/'
      'tenants/$_tenantId/barangays/$_barangayId/triage_alerts?pageSize=100&key=$_apiKey',
    );
    final request = await client.getUrl(uri).timeout(const Duration(seconds: 8));
    final response = await request.close().timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) return const [];

    final body = await utf8.decoder.bind(response).join();
    final decoded = jsonDecode(body);
    if (decoded is! Map || decoded['documents'] is! List) return const [];

    final updates = <RhuUpdate>[];
    for (final doc in decoded['documents'] as List) {
      if (doc is! Map || doc['fields'] is! Map) continue;
      final fields = Map<String, dynamic>.from(doc['fields'] as Map);
      if (_str(fields, 'bhw_id') != _bhwId) continue;
      final status = _str(fields, 'status');
      if (status.isEmpty || status == 'PENDING') continue;
      updates.add(
        RhuUpdate(
          alertUuid: _str(fields, 'alert_uuid'),
          patientName: _str(fields, 'patient_name'),
          sitioPurok: _str(fields, 'sitio_purok'),
          status: status,
          notes: _str(fields, 'resolution_notes'),
          actedAt: _time(fields, 'resolved_at') ?? _time(fields, 'triggered_at'),
        ),
      );
    }
    updates.sort((a, b) {
      final at = a.actedAt?.millisecondsSinceEpoch ?? 0;
      final bt = b.actedAt?.millisecondsSinceEpoch ?? 0;
      return bt.compareTo(at);
    });
    return updates.take(3).toList();
  } catch (_) {
    return const [];
  } finally {
    client.close(force: true);
  }
}

final rhuUpdatesProvider = FutureProvider.autoDispose<List<RhuUpdate>>((ref) {
  return fetchRhuUpdates();
});
