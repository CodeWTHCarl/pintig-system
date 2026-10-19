// lib/presentation/screens/immunization_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../state/immunization_intake_notifier.dart';
import '../theme/pintig_tokens.dart';
import '../widgets/accessible_form_widgets.dart';

class ImmunizationScreen extends ConsumerStatefulWidget {
  final AutoDisposeStateNotifierProvider<ImmunizationIntakeNotifier, ImmunizationFormState> provider;

  const ImmunizationScreen({super.key, required this.provider});

  @override
  ConsumerState<ImmunizationScreen> createState() => _ImmunizationScreenState();
}

class _ImmunizationScreenState extends ConsumerState<ImmunizationScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _lotController = TextEditingController();
  final TextEditingController _aefiNotesController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static const List<String> _antigens = ['BCG', 'HEPB', 'PENTA', 'OPV', 'IPV', 'PCV', 'MCV'];

  @override
  void initState() {
    super.initState();
    _dateController.text = _dateFormat.format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _lotController.dispose();
    _aefiNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref.read(widget.provider.notifier).setAdministrationDate(picked);
      _dateController.text = _dateFormat.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(widget.provider);
    final notifier = ref.read(widget.provider.notifier);

    ref.listen<ImmunizationFormState>(widget.provider, (prev, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Immunization record saved & queued for sync successfully (<=100ms)'),
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
        title: const Text('Immunization (TCL-EPI)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: PintigTokens.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deterministic Interval Violation Warning
            if (formState.intervalViolationMessage != null) ...[
              PintigCdssBanner(
                title: 'EPI Spacing Rule Violation',
                message: formState.intervalViolationMessage!,
                backgroundColor: PintigTokens.clinicalRed,
                icon: Icons.dangerous_outlined,
              ),
              const SizedBox(height: 16.0),
            ],

            // AEFI High-Risk CDSS Alert Banner
            if (formState.aefiReported) ...[
              const PintigCdssBanner(
                title: 'High Risk: Suspected AEFI Reaction',
                message:
                    'Adverse Event Following Immunization (High Fever >=38.5°C, convulsion, or severe local reaction). Immediate RHU Midwife/MHO referral required.',
                backgroundColor: PintigTokens.clinicalRed,
                icon: Icons.warning_amber_rounded,
              ),
              const SizedBox(height: 16.0),
            ] else ...[
              const PintigCdssBanner(
                title: 'Routine EPI Administration',
                message: 'No adverse post-vaccination reactions flagged. Cleared for standard dose logging.',
                backgroundColor: PintigTokens.clinicalGreen,
                icon: Icons.verified_user_outlined,
              ),
              const SizedBox(height: 16.0),
            ],

            // Antigen Selection Picker
            const Text(
              'Antigen Code (Bakuna) *',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _antigens.map((antigen) {
                final isSelected = formState.antigenCode == antigen;
                return ChoiceChip(
                  label: Text(
                    antigen,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : PintigTokens.textPrimary,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: PintigTokens.primaryBlue,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  onSelected: (selected) {
                    if (selected) notifier.setAntigen(antigen);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),

            // Dose Number Segmented Control
            const Text(
              'Dose Number *',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              height: PintigTokens.minTouchTarget,
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 1, label: Text('Dose 1')),
                  ButtonSegment(value: 2, label: Text('Dose 2')),
                  ButtonSegment(value: 3, label: Text('Dose 3')),
                ],
                selected: {formState.doseNumber},
                onSelectionChanged: (selection) => notifier.setDoseNumber(selection.first),
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: PintigTokens.primaryBlue,
                  selectedForegroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Administration Date
            PintigTextField(
              label: 'Administration Date (Adlaw sa Pagbakuna) *',
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              suffixIcon: const Icon(Icons.calendar_today, color: PintigTokens.primaryBlue),
            ),
            const SizedBox(height: 16.0),

            // Lot Number Field
            PintigTextField(
              label: 'Lot / Batch Number',
              hint: 'e.g. PENTA-2026-081',
              controller: _lotController,
              onChanged: notifier.setLotNumber,
            ),
            const SizedBox(height: 16.0),

            // AEFI / Severe Fever Toggle
            Container(
              decoration: BoxDecoration(
                color: formState.aefiReported ? const Color(0xFFFFF1F2) : Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: formState.aefiReported ? PintigTokens.clinicalRed : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Adverse Event / High Fever (AEFI)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
                subtitle: const Text(
                  'Toggle ON if child exhibits fever >=38.5°C, abscess, or severe reaction',
                  style: TextStyle(fontSize: 13.0),
                ),
                value: formState.aefiReported,
                activeColor: PintigTokens.clinicalRed,
                onChanged: notifier.setAefiReported,
              ),
            ),

            if (formState.aefiReported) ...[
              const SizedBox(height: 12.0),
              PintigTextField(
                label: 'Observed AEFI Symptoms / Reaction Notes',
                hint: 'e.g. Fever 39.1°C and injection site swelling',
                controller: _aefiNotesController,
                onChanged: notifier.setAefiSymptoms,
              ),
            ],

            const SizedBox(height: 24.0),

            // Save Record
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
}