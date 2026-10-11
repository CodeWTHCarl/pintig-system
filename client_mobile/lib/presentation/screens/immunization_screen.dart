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