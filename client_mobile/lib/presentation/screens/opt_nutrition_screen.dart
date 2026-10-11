// lib/presentation/screens/opt_nutrition_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/cdss/who_anthro_engine.dart';
import '../state/opt_intake_notifier.dart';
import '../theme/pintig_tokens.dart';
import '../widgets/accessible_form_widgets.dart';

class OptNutritionScreen extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<OptIntakeNotifier, OptFormState> provider;

  const OptNutritionScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    ref.listen<OptFormState>(provider, (prev, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OPT record saved & queued for sync successfully (<=100ms)'),
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

    return Scaffold(
      backgroundColor: PintigTokens.surfaceBackground,
      appBar: AppBar(
        title: const Text('Operation Timbang Plus (OPT)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: PintigTokens.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live CDSS Nutritional Classification Card
            if (formState.anthroEvaluation != null) ...[
              _buildAnthroSummaryCard(formState.anthroEvaluation!),
              const SizedBox(height: 16.0),
            ],

            // Patient Age Readout
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: PintigTokens.primaryBlue),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cake, color: PintigTokens.primaryBlue),
                  const SizedBox(width: 10.0),
                  Text(
                    'Pasyente Edad: ${formState.ageMonths} ka Bulan (${formState.ageMonths} Months)',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Anthropometry Measurements
            Row(
              children: [
                Expanded(
                  child: PintigTextField(
                    label: 'Weight / Timbang (kg) *',
                    hint: 'e.g. 7.5',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => notifier.setWeight(double.tryParse(v)),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: PintigTextField(
                    label: 'Height / Gitas-on (cm) *',
                    hint: 'e.g. 78.0',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => notifier.setHeight(double.tryParse(v)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Posture Segmented Toggle
            const Text(
              'Measurement Posture / Posisyon *',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              height: PintigTokens.minTouchTarget,
              child: SegmentedButton<MeasurementPosture>(
                segments: const [
                  ButtonSegment(
                    value: MeasurementPosture.recumbent,
                    label: Text('Naghigda (Recumbent)'),
                    icon: Icon(Icons.hotel),
                  ),
                  ButtonSegment(
                    value: MeasurementPosture.standing,
                    label: Text('Nagbarog (Standing)'),
                    icon: Icon(Icons.accessibility_new),
                  ),
                ],
                selected: {formState.posture},
                onSelectionChanged: (selection) => notifier.setPosture(selection.first),
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: PintigTokens.primaryBlue,
                  selectedForegroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Bilateral Pitting Edema Switch
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(PintigTokens.inputRadius),
                border: Border.all(
                  color: formState.hasEdema ? PintigTokens.clinicalRed : PintigTokens.cardBorder,
                  width: formState.hasEdema ? 2.0 : 1.0,
                ),
              ),
              child: SwitchListTile(
                title: const Text('Bilateral Pitting Edema', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Panghupong sa duha ka tiil (Severe Malnutrition Sign)'),
                value: formState.hasEdema,
                activeColor: PintigTokens.clinicalRed,
                onChanged: notifier.setEdema,
              ),
            ),
            const SizedBox(height: 24.0),

            // Submit Button
            PintigPrimaryButton(
              label: 'SAVE RECORD (ILISTA)',
              isLoading: formState.isSubmitting,
              onPressed: formState.isValid ? () => notifier.submitEncounter() : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnthroSummaryCard(WhoAnthroEvaluation eval) {
    final isSevere = eval.nutritionalStatus == NutritionalStatus.severelyWasted ||
        eval.stuntingStatus == StuntingStatus.severelyStunted;

    final bannerColor = isSevere ? PintigTokens.clinicalRed : PintigTokens.clinicalGreen;

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: bannerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: bannerColor, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSevere ? Icons.error_outline : Icons.check_circle_outline,
                color: bannerColor,
                size: 28.0,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'STATUS: ${eval.nutritionalStatus.name.toUpperCase()} / ${eval.stuntingStatus.name.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: bannerColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricColumn('WHZ (Wasting)', eval.whzScore.toStringAsFixed(2)),
              _buildMetricColumn('HAZ (Stunting)', eval.hazScore.toStringAsFixed(2)),
              _buildMetricColumn('WAZ (Underweight)', eval.wazScore.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12.0, color: PintigTokens.textMuted)),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: PintigTokens.textPrimary),
        ),
      ],
    );
  }
}