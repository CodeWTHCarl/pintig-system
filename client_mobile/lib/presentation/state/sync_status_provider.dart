import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database.dart';
import '../../data/services/sync_queue_dispatcher.dart';

enum SyncLifecycleState {
  idle,
  syncing,
  synced,
  error,
}

// Backward-compatible alias
typedef SyncStatus = SyncLifecycleState;

class SyncState {
  final SyncLifecycleState status;
  final int pendingCount;
  final DateTime? lastSyncedAt;
  final double lastCompressionRatio;
  final int lastLatencyMs;
  final String? errorMessage;

  const SyncState({
    this.status = SyncLifecycleState.idle,
    this.pendingCount = 0,
    this.lastSyncedAt,
    this.lastCompressionRatio = 1.0,
    this.lastLatencyMs = 0,
    this.errorMessage,
  });

  SyncState copyWith({
    SyncLifecycleState? status,
    int? pendingCount,
    DateTime? lastSyncedAt,
    double? lastCompressionRatio,
    int? lastLatencyMs,
    String? errorMessage,
  }) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastCompressionRatio: lastCompressionRatio ?? this.lastCompressionRatio,
      lastLatencyMs: lastLatencyMs ?? this.lastLatencyMs,
      errorMessage: errorMessage,
    );
  }
}

// Primary database provider expected by main.dart
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Alias for any service looking for databaseProvider
final databaseProvider = appDatabaseProvider;

final syncQueueDispatcherProvider = Provider<SyncQueueDispatcher>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncQueueDispatcher(
    db: db,
    deviceId: 'PINTIG-V2507A-EDGE',
  );
});

class SyncStatusNotifier extends StateNotifier<SyncState> {
  final AppDatabase _db;
  final SyncQueueDispatcher _dispatcher;
  StreamSubscription? _queueSubscription;

  SyncStatusNotifier({
    required AppDatabase db,
    required SyncQueueDispatcher dispatcher,
  })  : _db = db,
        _dispatcher = dispatcher,
        super(const SyncState()) {
    _initQueueWatcher();
  }

  void _initQueueWatcher() {
    final syncTable = _db.allTables.cast<TableInfo?>().firstWhere(
      (t) => t?.actualTableName == 'sync_queue',
      orElse: () => null,
    );

    _queueSubscription = _db.customSelect(
      "SELECT COUNT(*) AS count FROM sync_queue WHERE sync_status = 'PENDING'",
      readsFrom: syncTable != null ? {syncTable} : {},
    ).watch().listen((rows) {
      if (rows.isNotEmpty) {
        final count = rows.first.read<int>('count');
        state = state.copyWith(pendingCount: count);
      }
    });
  }

  Future<void> triggerSync() async {
    if (state.status == SyncLifecycleState.syncing) return;

    state = state.copyWith(status: SyncLifecycleState.syncing);

    final result = await _dispatcher.dispatchPendingQueue();

    final countRow = await _db.customSelect(
      "SELECT COUNT(*) AS count FROM sync_queue WHERE sync_status = 'PENDING'",
    ).getSingle();
    final remaining = countRow.read<int>('count');

    if (result.isSuccess) {
      state = state.copyWith(
        status: SyncLifecycleState.synced,
        pendingCount: remaining,
        lastSyncedAt: DateTime.now(),
        lastCompressionRatio: result.compressionRatio,
        lastLatencyMs: result.latencyMs,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        status: SyncLifecycleState.error,
        pendingCount: remaining,
        errorMessage: result.errorMessage,
      );
    }
  }

  Future<void> pushSync() => triggerSync();

  @override
  void dispose() {
    _queueSubscription?.cancel();
    super.dispose();
  }
}

final syncStatusProvider =
    StateNotifierProvider<SyncStatusNotifier, SyncState>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final dispatcher = ref.watch(syncQueueDispatcherProvider);
  return SyncStatusNotifier(
    db: db,
    dispatcher: dispatcher,
  );
});