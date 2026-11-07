// lib/presentation/screens/opt_nutrition_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/cdss/who_anthro_engine.dart';
import '../state/opt_intake_notifier.dart';
import '../theme/pintig_tokens.dart';
import '../widgets/accessible_form_widgets.dart';
import '../widgets/pintig_icons.dart';

class OptNutritionScreen extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<OptIntakeNotifier, OptFormState> provider;

  const OptNutritionScreen({super.key, required this.provider});

  static const List<String> _sitioOptions = [
    'Purok 1 (Centro)',
    'Purok 2',
    'Purok 3',
    'Purok 4',
    'Purok 5',
    'Sitio Tinago',
    'Sitio Anas',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    ref.listen<OptFormState>(provider, (prev, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Weighing saved. It will send when you have signal.'),
            backgroundColor: PintigTokens.clinicalGreen,
          ),
        );
        Navigator.of(context).pop();
      }
      if (next.submissionError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.submissionError!),
            backgroundColor: PintigTokens.clinicalRed,
          ),
        );
      }
    });

    final eval = formState.anthroEvaluation;

    return Scaffold(
      backgroundColor: PintigTokens.paper,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PintigScreenHeader(
              title: 'Child weighing',
              subtitle: 'Operation Timbang Plus (TCL-OPT)',
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PintigSectionTitle('Child'),
                    const SizedBox(height: 10.0),
                    PintigTextField(
                      label: 'Full name (Ngalan sa Bata)',
                      hint: 'e.g. Mateo Dela Cruz',
                      onChanged: notifier.setPatientName,
                    ),
                    const SizedBox(height: 14.0),
                    PintigDropdownField(
                      label: 'Sitio or purok',
                      value: formState.sitioPurok,
                      options: _sitioOptions,
                      onChanged: notifier.setSitioPurok,
                    ),
                    const SizedBox(height: 14.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: PintigTextField(
                            label: 'Age (0 to 59)',
                            hint: 'e.g. 12',
                            unit: 'months',
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.setAgeMonths(int.tryParse(v) ?? 18),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 6.0),
                                child: Text(
                                  'Sex (Sekso)',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: PintigTokens.ink,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 56.0,
                                width: double.infinity,
                                child: SegmentedButton<String>(
                                  showSelectedIcon: false,
                                  segments: const [
                                    ButtonSegment(value: 'M', label: Text('Male')),
                                    ButtonSegment(value: 'F', label: Text('Female')),
                                  ],
                                  selected: {formState.sex},
                                  onSelectionChanged: (sel) => notifier.setSex(sel.first),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26.0),

                    const PintigSectionTitle("Today's measurements"),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PintigTextField(
                            label: 'Weight (Timbang)',
                            hint: 'e.g. 6.8',
                            unit: 'kg',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => notifier.setWeight(double.tryParse(v)),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: PintigTextField(
                            label: 'Height (Gitas-on)',
                            hint: 'e.g. 75.0',
                            unit: 'cm',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => notifier.setHeight(double.tryParse(v)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        'How was the child measured? (Posisyon)',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: PintigTokens.ink,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: PintigTokens.minTouchTarget + 4.0,
                      child: SegmentedButton<MeasurementPosture>(
                        showSelectedIcon: false,
                        segments: [
                          ButtonSegment(
                            value: MeasurementPosture.recumbent,
                            label: const Text('Lying down'),
                            icon: PintigIcon(
                              PintigIconName.recumbent,
                              size: 22.0,
                              showDot: false,
                              color: formState.posture == MeasurementPosture.recumbent
                                  ? Colors.white
                                  : PintigTokens.ink,
                            ),
                          ),
                          ButtonSegment(
                            value: MeasurementPosture.standing,
                            label: const Text('Standing'),
                            icon: PintigIcon(
                              PintigIconName.standing,
                              size: 22.0,
                              showDot: false,
                              color: formState.posture == MeasurementPosture.standing
                                  ? Colors.white
                                  : PintigTokens.ink,
                            ),
                          ),
                        ],
                        selected: {formState.posture},
                        onSelectionChanged: (selection) => notifier.setPosture(selection.first),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: Text(
                        'Naghigda (lying down) or nagbarog (standing)',
                        style: TextStyle(fontSize: 13.5, color: PintigTokens.mutedText),
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    PintigToggleRow(
                      title: 'Swelling in both feet',
                      subtitle: 'Panghupong sa duha ka tiil (bilateral pitting edema, a sign of severe malnutrition)',
                      value: formState.hasEdema,
                      activeColor: PintigTokens.crimson,
                      activeTint: PintigTokens.roseTint,
                      onChanged: notifier.setEdema,
                    ),
                  ],
                ),
              ),
            ),
            PintigActionBar(
              banners: [
                if (eval != null) _buildAnthroSummaryCard(eval),
              ],
              disabledHint: formState.isValid ? null : 'Fill in the required fields to save.',
              button: PintigPrimaryButton(
                label: 'Save weighing',
                isLoading: formState.isSubmitting,
                onPressed: formState.isValid ? () => notifier.submitEncounter() : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// "severelyWasted" becomes "Severely wasted".
  String _humanize(String name) {
    final spaced = name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (m) => ' ${m.group(1)!.toLowerCase()}',
    );
    return spaced.isEmpty ? spaced : spaced[0].toUpperCase() + spaced.substring(1);
  }

  Widget _buildAnthroSummaryCard(WhoAnthroEvaluation eval) {
    final isSevere = eval.nutritionalStatus == NutritionalStatus.severelyWasted ||
        eval.stuntingStatus == StuntingStatus.severelyStunted;

    final tint = isSevere ? PintigTokens.roseTint : PintigTokens.seaTint;
    final ink = isSevere ? PintigTokens.roseInk : PintigTokens.seaInk;
    final accent = isSevere ? PintigTokens.crimson : PintigTokens.sea;

    return Semantics(
      liveRegion: true,
      container: true,
      label: '${isSevere ? 'Severe malnutrition risk. ' : ''}'
          '${_humanize(eval.nutritionalStatus.name)}, ${_humanize(eval.stuntingStatus.name)}',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: accent.withOpacity(0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  PintigIcon(
                    isSevere ? PintigIconName.alert : PintigIconName.check,
                    size: 28.0,
                    color: accent,
                    dotColor: accent,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      '${_humanize(eval.nutritionalStatus.name)}. ${_humanize(eval.stuntingStatus.name)}.',
                      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: ink),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricColumn('WHZ', 'wasting', eval.whzScore.toStringAsFixed(2), ink),
                  _buildMetricColumn('HAZ', 'stunting', eval.hazScore.toStringAsFixed(2), ink),
                  _buildMetricColumn('WAZ', 'underweight', eval.wazScore.toStringAsFixed(2), ink),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String code, String word, String value, Color ink) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: ink)),
        Text('$code $word', style: TextStyle(fontSize: 12.5, color: ink)),
      ],
    );
  }
}
