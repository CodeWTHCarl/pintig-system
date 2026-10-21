// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/sync_worker.dart';
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

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await PintigSyncWorkerManager.initialize('PINTIG-V2507A-EDGE');
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
      title: 'Pintig',
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
          backgroundColor: PintigTokens.deepNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
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

    const demoPatientUuid = '22222222-0000-4000-8000-000000000001';
    const demoBhwId = 'BHW-NAV-01';

    final bool hasPending = syncState.pendingCount > 0;
    final bool isSyncing = syncState.status == SyncLifecycleState.syncing;
    final bool isError = syncState.status == SyncLifecycleState.error;

    return Scaffold(
      backgroundColor: PintigTokens.surfaceBackground,
      body: CustomScrollView(
        slivers: [
          // UI/UX Pro Max Hero Header with Official Pintig Logo
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(
                top: 56.0,
                left: 20.0,
                right: 20.0,
                bottom: 28.0,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E1B2E),
                    Color(0xFF7F1D1D),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const PintigBrandLogo(size: 52.0),
                      const SizedBox(width: 14.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Pintig',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 2.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PintigTokens.pintigCoral.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: PintigTokens.pintigCoral.withOpacity(0.5),
                                    ),
                                  ),
                                  child: const Text(
                                    'EDGE CDSS',
                                    style: TextStyle(
                                      color: Color(0xFFFCA5A5),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3.0),
                            const Text(
                              'The Heartbeat of Last-Mile Healthcare',
                              style: TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: IconButton(
                          tooltip: 'Push Sync Now',
                          icon: isSyncing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.2,
                                  ),
                                )
                              : const Icon(Icons.sync_rounded, color: Colors.white),
                          onPressed: () => ref.read(syncStatusProvider.notifier).pushSync(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // Active Field Jurisdiction Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_on_rounded, color: Color(0xFFF87171), size: 17.0),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Brgy. P.I. Garcia, Naval • Officer: BHW-NAV-01',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(Icons.shield_outlined, color: Color(0xFF34D399), size: 15.0),
                        SizedBox(width: 4.0),
                        Text(
                          'SQLite Offline',
                          style: TextStyle(
                            color: Color(0xFFA7F3D0),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content Body
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Bento Sync Queue & Cloud Dispatch Card
                Container(
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: hasPending
                          ? PintigTokens.clinicalAmber.withOpacity(0.5)
                          : PintigTokens.cardBorder,
                      width: hasPending ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52.0,
                            height: 52.0,
                            decoration: BoxDecoration(
                              color: hasPending
                                  ? const Color(0xFFFEF3C7)
                                  : isError
                                      ? const Color(0xFFFFE4E6)
                                      : const Color(0xFFD1FAE5),
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            child: Icon(
                              hasPending
                                  ? Icons.cloud_upload_rounded
                                  : isError
                                      ? Icons.cloud_off_rounded
                                      : Icons.cloud_done_rounded,
                              color: hasPending
                                  ? PintigTokens.clinicalAmber
                                  : isError
                                      ? PintigTokens.clinicalRed
                                      : PintigTokens.clinicalGreen,
                              size: 28.0,
                            ),
                          ),
                          const SizedBox(width: 14.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Pending Sync: ${syncState.pendingCount} records',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16.5,
                                        color: PintigTokens.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7.0,
                                        vertical: 2.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isError
                                            ? const Color(0xFFFFE4E6)
                                            : hasPending
                                                ? const Color(0xFFFEF3C7)
                                                : const Color(0xFFD1FAE5),
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      child: Text(
                                        syncState.status.name.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w800,
                                          color: isError
                                              ? PintigTokens.clinicalRed
                                              : hasPending
                                                  ? PintigTokens.clinicalAmber
                                                  : PintigTokens.clinicalGreen,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  hasPending
                                      ? 'Staged in encrypted local storage awaiting cloud dispatch'
                                      : 'Synchronized with Naval RHU Command Portal',
                                  style: const TextStyle(
                                    color: PintigTokens.textMuted,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: hasPending
                                ? PintigTokens.primaryBlue
                                : PintigTokens.deepNavy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: isSyncing
                              ? null
                              : () => ref.read(syncStatusProvider.notifier).pushSync(),
                          icon: Icon(
                            isSyncing ? Icons.hourglass_top_rounded : Icons.cloud_sync_rounded,
                            size: 18.0,
                          ),
                          label: Text(
                            isSyncing ? 'DISPATCHING TO RHU CLOUD...' : 'PUSH SYNC NOW',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13.5,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28.0),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TARGET CLIENT LISTS (DOH TCL)',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                        color: PintigTokens.textMuted,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      'FHSIS 2026 Compliant',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: PintigTokens.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // 1. Maternal Care (TCL-MC)
                _buildModuleCard(
                  context: context,
                  badgeCode: 'TCL-MC',
                  title: 'Maternal Care (TCL-MC)',
                  subtitle: 'Prenatal visits, blood pressure triage & Naegele EDC',
                  visayanHint: 'Pag-atiman sa Mabdos ug Presyon sa Dugo',
                  icon: Icons.pregnant_woman_rounded,
                  accentColor: const Color(0xFFC81E2B),
                  lightBgColor: const Color(0xFFFFF1F2),
                  onTap: () {
                    final provider = StateNotifierProvider.autoDispose<MaternalIntakeNotifier,
                        MaternalCareFormState>((ref) {
                      return MaternalIntakeNotifier(
                        repository: repository,
                        patientUuid: demoPatientUuid,
                        bhwUserId: demoBhwId,
                      );
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => MaternalIntakeScreen(provider: provider)),
                    );
                  },
                ),
                const SizedBox(height: 14.0),

                // 2. Operation Timbang Plus (TCL-OPT)
                _buildModuleCard(
                  context: context,
                  badgeCode: 'TCL-OPT+',
                  title: 'Operation Timbang Plus (TCL-OPT)',
                  subtitle: 'WHO child growth Z-scores (WAZ, HAZ, WHZ) & SAM triage',
                  visayanHint: 'Timbang ug Gitas-on sa Bata (0–59 ka Bulan)',
                  icon: Icons.child_care_rounded,
                  accentColor: const Color(0xFF059669),
                  lightBgColor: const Color(0xFFECFDF5),
                  onTap: () {
                    final provider =
                        StateNotifierProvider.autoDispose<OptIntakeNotifier, OptFormState>((ref) {
                      return OptIntakeNotifier(
                        repository: repository,
                        patientUuid: demoPatientUuid,
                        patientSex: 'M',
                        bhwUserId: demoBhwId,
                        initialBirthdate: DateTime.now().subtract(const Duration(days: 540)),
                      );
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => OptNutritionScreen(provider: provider)),
                    );
                  },
                ),
                const SizedBox(height: 14.0),

                // 3. Immunization (TCL-EPI)
                _buildModuleCard(
                  context: context,
                  badgeCode: 'TCL-EPI',
                  title: 'Immunization (TCL-EPI)',
                  subtitle: 'DOH antigens, 28-day dose intervals & AEFI fever alert',
                  visayanHint: 'Bakuna sa Bata ug Bantay sa Kalit nga Hilanat',
                  icon: Icons.vaccines_rounded,
                  accentColor: const Color(0xFF0284C7),
                  lightBgColor: const Color(0xFFF0F9FF),
                  onTap: () async {
                    final history =
                        await repository.getPatientImmunizationHistory(demoPatientUuid);
                    final provider = StateNotifierProvider.autoDispose<ImmunizationIntakeNotifier,
                        ImmunizationFormState>((ref) {
                      return ImmunizationIntakeNotifier(
                        repository: repository,
                        patientUuid: demoPatientUuid,
                        bhwUserId: demoBhwId,
                        history: history,
                      );
                    });
                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ImmunizationScreen(provider: provider)),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24.0),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required BuildContext context,
    required String badgeCode,
    required String title,
    required String subtitle,
    required String visayanHint,
    required IconData icon,
    required Color accentColor,
    required Color lightBgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: PintigTokens.cardBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(18.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54.0,
                  height: 54.0,
                  decoration: BoxDecoration(
                    color: lightBgColor,
                    borderRadius: BorderRadius.circular(14.0),
                    border: Border.all(color: accentColor.withOpacity(0.25)),
                  ),
                  child: Icon(icon, color: accentColor, size: 30.0),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7.0,
                              vertical: 2.0,
                            ),
                            decoration: BoxDecoration(
                              color: lightBgColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              badgeCode,
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              visayanHint,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: PintigTokens.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: PintigTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: PintigTokens.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16.0,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}