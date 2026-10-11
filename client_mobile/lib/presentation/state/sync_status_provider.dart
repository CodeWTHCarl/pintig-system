// lib/presentation/state/sync_status_provider.dart
import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync_worker.dart';
import '../../data/local/database.dart';
import '../../data/services/sync_queue_dispatcher.dart';

enum SyncLifecycleState { idle, syncing, synced, error }

class SyncState {
  final SyncLifecycleState status;
  final int pendingCount;
  final int inFlightCount;
  final DateTime? lastSyncedAt;
  final String? errorMessage;
  final double? lastCompressionRatio;

  const SyncState({
    required this.status,
    this.pendingCount = 0,
    this.inFlightCount = 0,
    this.lastSyncedAt,
    this.errorMessage,
    this.lastCompressionRatio,
  });

  SyncState copyWith({
    SyncLifecycleState? status,
    int? pendingCount,
    int? inFlightCount,
    DateTime? lastSyncedAt,
    String? errorMessage,
    double? lastCompressionRatio,
    bool clearError = false,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      inFlightCount: inFlightCount ?? this.inFlightCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastCompressionRatio: lastCompressionRatio ?? this.lastCompressionRatio,
    );
  }
}

class SyncStatusNotifier extends StateNotifier<SyncState> {
  final AppDatabase _db;
  final SyncQueueDispatcher _dispatcher;
  StreamSubscription<int>? _queueSubscription;

  SyncStatusNotifier({
    required AppDatabase db,
    required SyncQueueDispatcher dispatcher,
  })  : _db = db,
        _dispatcher = dispatcher,
        super(const SyncState(status: SyncLifecycleState.idle)) {
    _bindQueueWatcher();
  }

  void _bindQueueWatcher() {
    final pendingQuery = _db.select(_db.syncQueue)
      ..where((tbl) => tbl.syncStatus.equals('PENDING'));

    _queueSubscription = pendingQuery.watch().map((rows) => rows.length).listen((count) {
      state = state.copyWith(pendingCount: count);
    });
  }

  Future<void> pushSync() async {
    if (state.status == SyncLifecycleState.syncing) return;

    state = state.copyWith(
      status: SyncLifecycleState.syncing,
      clearError: true,
    );

    // Concurrently queue WorkManager background recovery task
    await PintigSyncWorkerManager.triggerImmediateSync();

    // Execute direct synchronous transport pipeline on device foreground thread
    final result = await _dispatcher.dispatchPendingQueue();

    if (result.isSuccess) {
      state = state.copyWith(
        status: SyncLifecycleState.synced,
        lastSyncedAt: DateTime.now(),
        lastCompressionRatio: result.compressionRatio,
      );
    } else {
      state = state.copyWith(
        status: SyncLifecycleState.error,
        errorMessage: result.errorMessage ?? 'Unknown synchronization transport failure',
      );
    }
  }

  @override
  void dispose() {
    _queueSubscription?.cancel();
    super.dispose();
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final syncDispatcherProvider = Provider<SyncQueueDispatcher>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncQueueDispatcher(
    db: db,
    deviceId: 'PINTIG-DEV-SAMSUNG-A03-01',
  );
});

final syncStatusProvider = StateNotifierProvider<SyncStatusNotifier, SyncState>((ref) {
  return SyncStatusNotifier(
    db: ref.watch(appDatabaseProvider),
    dispatcher: ref.watch(syncDispatcherProvider),
  );
});