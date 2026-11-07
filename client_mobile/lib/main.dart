// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'core/sync_worker.dart';
import 'data/repositories/encounter_repository.dart';
import 'presentation/screens/immunization_screen.dart';
import 'presentation/screens/maternal_intake_screen.dart';
import 'presentation/screens/opt_nutrition_screen.dart';
import 'presentation/state/immunization_intake_notifier.dart';
import 'presentation/state/maternal_intake_notifier.dart';
import 'presentation/state/opt_intake_notifier.dart';
import 'presentation/state/rhu_updates_provider.dart';
import 'presentation/state/sync_status_provider.dart';
import 'presentation/theme/pintig_tokens.dart';
import 'presentation/widgets/pintig_icons.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
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
      theme: PintigTheme.light(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncStatusProvider);
    final updatesAsync = ref.watch(rhuUpdatesProvider);
    final db = ref.watch(appDatabaseProvider);
    final repository = EncounterRepository(db);

    // Pull the RHU's responses again each time a send finishes.
    ref.listen<SyncState>(syncStatusProvider, (previous, next) {
      if (previous?.status != next.status && next.status == SyncLifecycleState.synced) {
        ref.invalidate(rhuUpdatesProvider);
      }
    });

    const demoPatientUuid = '22222222-0000-4000-8000-000000000001';
    const demoBhwId = 'BHW-NAV-01';

    final updates = updatesAsync.valueOrNull ?? const <RhuUpdate>[];

    return Scaffold(
      backgroundColor: PintigTokens.paper,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: PintigTokens.crimson,
                onRefresh: () async {
                  ref.invalidate(rhuUpdatesProvider);
                  await ref.read(rhuUpdatesProvider.future);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 24.0),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 28.0),
                    const PintigSectionTitleHome('Start a visit'),
                    const SizedBox(height: 10.0),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18.0),
                      child: Material(
                        color: Colors.white,
                        child: Column(
                          children: [
                            _buildVisitRow(
                              icon: PintigIconName.prenatal,
                              iconColor: PintigTokens.crimson,
                              tint: PintigTokens.roseTint,
                              title: 'Prenatal visit',
                              hint: 'Pag-atiman sa Mabdos ug Presyon sa Dugo',
                              code: 'TCL-MC',
                              onTap: () {
                                final provider = StateNotifierProvider.autoDispose<
                                    MaternalIntakeNotifier, MaternalCareFormState>((ref) {
                                  return MaternalIntakeNotifier(
                                    repository: repository,
                                    patientUuid: demoPatientUuid,
                                    bhwUserId: demoBhwId,
                                  );
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => MaternalIntakeScreen(provider: provider),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1.0, color: PintigTokens.line),
                            _buildVisitRow(
                              icon: PintigIconName.child,
                              iconColor: PintigTokens.sea,
                              tint: PintigTokens.seaTint,
                              title: 'Child weighing',
                              hint: 'Timbang ug Gitas-on sa Bata (0–59 ka Bulan)',
                              code: 'TCL-OPT+',
                              onTap: () {
                                final provider = StateNotifierProvider.autoDispose<
                                    OptIntakeNotifier, OptFormState>((ref) {
                                  return OptIntakeNotifier(
                                    repository: repository,
                                    patientUuid: demoPatientUuid,
                                    patientSex: 'M',
                                    bhwUserId: demoBhwId,
                                    initialBirthdate:
                                        DateTime.now().subtract(const Duration(days: 540)),
                                  );
                                });
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OptNutritionScreen(provider: provider),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1.0, color: PintigTokens.line),
                            _buildVisitRow(
                              icon: PintigIconName.vaccine,
                              iconColor: PintigTokens.ink,
                              tint: const Color(0xFFE6EAEE),
                              title: 'Vaccination',
                              hint: 'Bakuna sa Bata ug Bantay sa Kalit nga Hilanat',
                              code: 'TCL-EPI',
                              onTap: () async {
                                final history = await repository
                                    .getPatientImmunizationHistory(demoPatientUuid);
                                final provider = StateNotifierProvider.autoDispose<
                                    ImmunizationIntakeNotifier, ImmunizationFormState>((ref) {
                                  return ImmunizationIntakeNotifier(
                                    repository: repository,
                                    patientUuid: demoPatientUuid,
                                    bhwUserId: demoBhwId,
                                    history: history,
                                  );
                                });
                                if (context.mounted) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ImmunizationScreen(provider: provider),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (updates.isNotEmpty) ...[
                      const SizedBox(height: 28.0),
                      const PintigSectionTitleHome('Updates from the RHU'),
                      const SizedBox(height: 10.0),
                      for (final u in updates) ...[
                        _buildUpdateCard(u),
                        const SizedBox(height: 10.0),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            _buildSyncBar(context, ref, syncState),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const PintigBrandLogo(size: 52.0),
        const SizedBox(width: 14.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: const Text(
                  'Brgy. P.I. Garcia',
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: PintigTokens.ink,
                  ),
                ),
              ),
              const Text(
                'Naval, Biliran. BHW-NAV-01',
                style: TextStyle(fontSize: 14.0, color: PintigTokens.mutedText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVisitRow({
    required PintigIconName icon,
    required Color iconColor,
    required Color tint,
    required String title,
    required String hint,
    required String code,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      minVerticalPadding: 14.0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Container(
        width: 46.0,
        height: 46.0,
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(13.0),
        ),
        alignment: Alignment.center,
        child: PintigIcon(icon, size: 26.0, color: iconColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: PintigTokens.ink,
        ),
      ),
      subtitle: Text(
        hint,
        style: const TextStyle(fontSize: 14.0, color: PintigTokens.mutedText, height: 1.3),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            code,
            style: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: PintigTokens.mutedText,
            ),
          ),
          const SizedBox(width: 6.0),
          const PintigIcon(PintigIconName.chevronR, size: 20.0, showDot: false),
        ],
      ),
    );
  }

  Widget _buildUpdateCard(RhuUpdate u) {
    final who = [u.patientName, u.sitioPurok].where((s) => s.isNotEmpty).join(', ');
    final time = u.actedAt == null ? '' : ' at ${DateFormat.jm().format(u.actedAt!)}';
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: PintigTokens.seaTint,
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PintigIcon(
            PintigIconName.check,
            size: 24.0,
            color: PintigTokens.sea,
            showDot: false,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  who.isEmpty ? 'Patient' : who,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: PintigTokens.seaInk,
                  ),
                ),
                Text(
                  '${u.statusLabel}$time',
                  style: const TextStyle(fontSize: 14.5, color: PintigTokens.seaInk),
                ),
                if (u.notes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      u.notes,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1.35,
                        color: PintigTokens.seaInk,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncBar(BuildContext context, WidgetRef ref, SyncState syncState) {
    final bool isSyncing = syncState.status == SyncLifecycleState.syncing;
    final bool isError = syncState.status == SyncLifecycleState.error;
    final int pending = syncState.pendingCount;
    final bool hasPending = pending > 0;

    final String title;
    final String detail;
    final PintigIconName icon;
    final Color accent;

    if (isSyncing) {
      title = 'Sending your visits';
      detail = 'Keep the app open for a moment.';
      icon = PintigIconName.send;
      accent = PintigTokens.ink;
    } else if (isError) {
      title = 'Could not reach the RHU';
      detail = 'Your visits are safe on this phone. Try again when you have signal.';
      icon = PintigIconName.alert;
      accent = PintigTokens.crimson;
    } else if (hasPending) {
      final noun = pending == 1 ? 'visit' : 'visits';
      title = '$pending $noun waiting to send';
      detail = 'Saved on this phone. Sends when you have signal.';
      icon = PintigIconName.saved;
      accent = PintigTokens.amber;
    } else {
      title = 'All visits sent';
      detail = syncState.lastSyncedAt == null
          ? 'Everything on this phone is with the RHU.'
          : 'Last sent at ${DateFormat.jm().format(syncState.lastSyncedAt!)}.';
      icon = PintigIconName.saved;
      accent = PintigTokens.sea;
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: PintigTokens.line)),
      ),
      padding: EdgeInsets.fromLTRB(
        20.0,
        14.0,
        20.0,
        14.0 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          PintigIcon(icon, size: 30.0, color: accent, dotColor: accent),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  liveRegion: true,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: PintigTokens.ink,
                    ),
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.3,
                    color: PintigTokens.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          SizedBox(
            height: 48.0,
            child: FilledButton(
              onPressed: isSyncing || (!hasPending && !isError)
                  ? null
                  : () => ref.read(syncStatusProvider.notifier).pushSync(),
              style: FilledButton.styleFrom(
                backgroundColor: PintigTokens.crimson,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFD5DCE1),
                disabledForegroundColor: PintigTokens.mutedText,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              child: Text(isSyncing ? 'Sending' : 'Send now'),
            ),
          ),
        ],
      ),
    );
  }
}

class PintigSectionTitleHome extends StatelessWidget {
  final String text;
  const PintigSectionTitleHome(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: PintigTokens.ink,
        ),
      ),
    );
  }
}
