// lib/presentation/screens/immunization_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../state/immunization_intake_notifier.dart';
import '../theme/pintig_tokens.dart';
import '../widgets/accessible_form_widgets.dart';
import '../widgets/pintig_icons.dart';

class ImmunizationScreen extends ConsumerStatefulWidget {
  final AutoDisposeStateNotifierProvider<ImmunizationIntakeNotifier, ImmunizationFormState> provider;

  const ImmunizationScreen({super.key, required this.provider});

  @override
  ConsumerState<ImmunizationScreen> createState() => _ImmunizationScreenState();
}

class _ImmunizationScreenState extends ConsumerState<ImmunizationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _lotController = TextEditingController();
  final TextEditingController _aefiNotesController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  static const List<String> _antigens = ['BCG', 'HEPB', 'PENTA', 'OPV', 'IPV', 'PCV', 'MCV'];
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
  void initState() {
    super.initState();
    _dateController.text = _dateFormat.format(DateTime.now());
  }

  @override
  void dispose() {
    _nameController.dispose();
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
            content: Text('Vaccination saved. It will send when you have signal.'),
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
      backgroundColor: PintigTokens.paper,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PintigScreenHeader(
              title: 'Vaccination',
              subtitle: 'Immunization (TCL-EPI)',
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
                      hint: 'e.g. Lucas Villanueva',
                      controller: _nameController,
                      onChanged: notifier.setPatientName,
                    ),
                    const SizedBox(height: 14.0),
                    PintigDropdownField(
                      label: 'Sitio or purok',
                      value: formState.sitioPurok,
                      options: _sitioOptions,
                      onChanged: notifier.setSitioPurok,
                    ),
                    const SizedBox(height: 26.0),

                    const PintigSectionTitle('Vaccine given (Bakuna)'),
                    const SizedBox(height: 10.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _antigens.map((antigen) {
                        final isSelected = formState.antigenCode == antigen;
                        return ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            antigen,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : PintigTokens.ink,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: PintigTokens.ink,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: isSelected ? PintigTokens.ink : PintigTokens.fieldBorder,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                          onSelected: (selected) {
                            if (selected) notifier.setAntigen(antigen);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18.0),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        'Dose number',
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
                      child: SegmentedButton<int>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(value: 1, label: Text('Dose 1')),
                          ButtonSegment(value: 2, label: Text('Dose 2')),
                          ButtonSegment(value: 3, label: Text('Dose 3')),
                        ],
                        selected: {formState.doseNumber},
                        onSelectionChanged: (selection) => notifier.setDoseNumber(selection.first),
                      ),
                    ),
                    const SizedBox(height: 26.0),

                    const PintigSectionTitle('Details'),
                    const SizedBox(height: 10.0),
                    PintigTextField(
                      label: 'Date given (Adlaw sa Pagbakuna)',
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      suffixIcon: const PintigIcon(PintigIconName.calendar, size: 24.0),
                    ),
                    const SizedBox(height: 14.0),
                    PintigTextField(
                      label: 'Lot or batch number',
                      hint: 'e.g. PENTA-2026-081',
                      controller: _lotController,
                      onChanged: notifier.setLotNumber,
                    ),
                    const SizedBox(height: 18.0),
                    PintigToggleRow(
                      title: 'Bad reaction or high fever (AEFI)',
                      subtitle: 'Turn on if the child has fever of 38.5°C or more, an abscess, or a severe reaction',
                      value: formState.aefiReported,
                      activeColor: PintigTokens.crimson,
                      activeTint: PintigTokens.roseTint,
                      onChanged: notifier.setAefiReported,
                    ),
                    if (formState.aefiReported) ...[
                      const SizedBox(height: 12.0),
                      PintigTextField(
                        label: 'What did you see?',
                        hint: 'e.g. Fever 39.1°C and injection site swelling',
                        controller: _aefiNotesController,
                        onChanged: notifier.setAefiSymptoms,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            PintigActionBar(
              banners: [
                if (formState.intervalViolationMessage != null)
                  PintigCdssBanner(
                    title: 'Too soon for this dose',
                    message: formState.intervalViolationMessage!,
                    tone: PintigTone.critical,
                    icon: PintigIconName.waiting,
                  ),
                if (formState.aefiReported)
                  const PintigCdssBanner(
                    title: 'Suspected reaction. Refer to the RHU.',
                    message:
                        'High fever (38.5°C or more), convulsion, or a severe local reaction needs the RHU midwife or MHO right away.',
                    tone: PintigTone.critical,
                    icon: PintigIconName.alert,
                  ),
              ],
              disabledHint: formState.isValid ? null : 'Fill in the required fields to save.',
              button: PintigPrimaryButton(
                label: 'Save vaccination',
                isLoading: formState.isSubmitting,
                onPressed: formState.isValid ? () => notifier.submitEncounter() : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
