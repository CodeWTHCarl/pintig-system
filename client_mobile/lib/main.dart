import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/sync_worker.dart';
import 'data/local/database.dart';
import 'data/repositories/encounter_repository.dart';
import 'presentation/screens/immunization_screen.dart';
import 'presentation/screens/maternal_intake_screen.dart';
import 'presentation/screens/opt_nutrition_screen.dart';
import 'presentation/state/immunization_intake_notifier.dart';
import 'presentation/state/maternal_intake_notifier.dart';
import 'presentation/state/opt_intake_notifier.dart';
import 'presentation/state/sync_status_provider.dart';
import 'presentation/theme/pintig_tokens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize WorkManager with your physical device ID
  await PintigSyncWorkerManager.initialize('PINTIG-DEV-SAMSUNG-A03-01');
  await PintigSyncWorkerManager.registerPeriodicSync();

  runApp(
    const ProviderScope(
      child: PintigApp(),
    ),
  );
}

class PintigApp extends StatelessWidget {
  const PintigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pintig Edge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: PintigTokens.surfaceBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PintigTokens.primaryBlue,
          primary: PintigTokens.primaryBlue,
          surface: PintigTokens.surfaceBackground,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: PintigTokens.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStatusProvider);
    final db = ref.watch(appDatabaseProvider);
    final repository = EncounterRepository(db);

    // Dummy patient context for field demonstration
    const demoPatientUuid = '22222222-0000-4000-8000-000000000001';
    const demoBhwId = 'BHW-NAV-01';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pintig: Brgy. P.I. Garcia'),
        actions: [
          IconButton(
            tooltip: 'Push Sync Now',
            icon: syncState.status == SyncLifecycleState.syncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            onPressed: () => ref.read(syncStatusProvider.notifier).pushSync(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Offline Status & Sync Badge Card
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: PintigTokens.cardBorder),
            ),
            child: Row(
              children: [
                Icon(
                  syncState.pendingCount > 0 ? Icons.cloud_queue : Icons.cloud_done,
                  color: syncState.pendingCount > 0 ? PintigTokens.clinicalAmber : PintigTokens.clinicalGreen,
                  size: 36,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Sync: ${syncState.pendingCount} records',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Status: ${syncState.status.name.toUpperCase()}',
                        style: TextStyle(
                          color: syncState.status == SyncLifecycleState.error ? PintigTokens.clinicalRed : PintigTokens.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PintigTokens.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => ref.read(syncStatusProvider.notifier).pushSync(),
                  child: const Text('PUSH SYNC'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'TARGET CLIENT LISTS (TCL)',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: PintigTokens.textMuted),
          ),
          const SizedBox(height: 12),

          // TCL-MC Intake Card
          Card(
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(Icons.pregnant_woman, color: PintigTokens.primaryBlue, size: 36),
              title: const Text('Maternal Care (TCL-MC)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Prenatal visits, blood pressure triage, Naegele EDC'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final provider = StateNotifierProvider.autoDispose<MaternalIntakeNotifier, MaternalCareFormState>((ref) {
                  return MaternalIntakeNotifier(
                    repository: repository,
                    patientUuid: demoPatientUuid,
                    bhwUserId: demoBhwId,
                  );
                });
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => MaternalIntakeScreen(provider: provider)));
              },
            ),
          ),
          const SizedBox(height: 8),

          // TCL-OPT Intake Card
          Card(
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(Icons.child_care, color: PintigTokens.clinicalGreen, size: 36),
              title: const Text('Operation Timbang Plus (TCL-OPT)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('WHO child growth z-scores (WAZ, HAZ, WHZ)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final provider = StateNotifierProvider.autoDispose<OptIntakeNotifier, OptFormState>((ref) {
                  return OptIntakeNotifier(
                    repository: repository,
                    patientUuid: demoPatientUuid,
                    patientSex: 'M',
                    bhwUserId: demoBhwId,
                    initialBirthdate: DateTime.now().subtract(const Duration(days: 540)), // 18 months
                  );
                });
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => OptNutritionScreen(provider: provider)));
              },
            ),
          ),
          const SizedBox(height: 8),

          // TCL-EPI Intake Card
          Card(
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(Icons.vaccines, color: PintigTokens.clinicalAmber, size: 36),
              title: const Text('Immunization (TCL-EPI)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('DOH antigens, dose intervals, defaulter check'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final history = await repository.getPatientImmunizationHistory(demoPatientUuid);
                final provider = StateNotifierProvider.autoDispose<ImmunizationIntakeNotifier, ImmunizationFormState>((ref) {
                  return ImmunizationIntakeNotifier(
                    repository: repository,
                    patientUuid: demoPatientUuid,
                    bhwUserId: demoBhwId,
                    history: history,
                  );
                });
                if (context.mounted) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ImmunizationScreen(provider: provider)));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}