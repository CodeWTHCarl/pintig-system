// lib/core/sync_worker.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../data/local/database.dart';
import '../data/services/sync_queue_dispatcher.dart';

const String kPintigPeriodicSyncTask = 'ph.biliran.pintig.periodic_sync';
const String kPintigOneOffSyncTask = 'ph.biliran.pintig.immediate_sync';
const String kPrefDeviceIdKey = 'pintig_cached_device_id';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString(kPrefDeviceIdKey) ?? 'PINTIG-PROD-EDGE-CLIENT';

      // Open isolated local database instance on background isolate
      final db = AppDatabase();
      final dispatcher = SyncQueueDispatcher(
        db: db,
        deviceId: deviceId,
      );

      final result = await dispatcher.dispatchPendingQueue();
      await db.close();

      return Future.value(result.isSuccess);
    } catch (e) {
      debugPrint('SyncWorker execution error: $e');
      return Future.value(false);
    }
  });
}

class PintigSyncWorkerManager {
  static Future<void> initialize(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefDeviceIdKey, deviceId);

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  static Future<void> registerPeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      kPintigPeriodicSyncTask,
      kPintigPeriodicSyncTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(seconds: 30),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  static Future<void> triggerImmediateSync() async {
    await Workmanager().registerOneOffTask(
      '${kPintigOneOffSyncTask}_${DateTime.now().millisecondsSinceEpoch}',
      kPintigOneOffSyncTask,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      backoffPolicy: BackoffPolicy.exponential,
      backoffPolicyDelay: const Duration(seconds: 15),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }
}