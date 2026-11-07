// lib/presentation/screens/maternal_intake_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/cdss/maternal_triage_engine.dart';
import '../state/maternal_intake_notifier.dart';
import '../theme/pintig_tokens.dart';
import '../widgets/accessible_form_widgets.dart';
import '../widgets/pintig_icons.dart';

class MaternalIntakeScreen extends ConsumerStatefulWidget {
  final AutoDisposeStateNotifierProvider<MaternalIntakeNotifier, MaternalCareFormState> provider;

  const MaternalIntakeScreen({super.key, required this.provider});

  @override
  ConsumerState<MaternalIntakeScreen> createState() => _MaternalIntakeScreenState();
}

class _MaternalIntakeScreenState extends ConsumerState<MaternalIntakeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lmpController = TextEditingController();
  final TextEditingController _edcController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _fundicController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

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
  void dispose() {
    _nameController.dispose();
    _lmpController.dispose();
    _edcController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _weightController.dispose();
    _fundicController.dispose();
    super.dispose();
  }

  Future<void> _selectLmpDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 60)),
      firstDate: now.subtract(const Duration(days: 300)),
      lastDate: now,
    );
    if (picked != null) {
      ref.read(widget.provider.notifier).setLmpDate(picked);
      _lmpController.text = _dateFormat.format(picked);
      _edcController.text = _dateFormat.format(picked.add(const Duration(days: 280)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(widget.provider);
    final notifier = ref.read(widget.provider.notifier);

    ref.listen<MaternalCareFormState>(widget.provider, (prev, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Visit saved. It will send when you have signal.'),
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

    final triage = formState.triageResult;
    final PintigTone triageTone = triage == null
        ? PintigTone.caution
        : (triage.riskLevel == TriageRiskLevel.high
            ? PintigTone.critical
            : (triage.riskLevel == TriageRiskLevel.normal ? PintigTone.ok : PintigTone.caution));

    return Scaffold(
      backgroundColor: PintigTokens.paper,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PintigScreenHeader(
              title: 'Prenatal visit',
              subtitle: 'Maternal care (TCL-MC)',
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PintigSectionTitle('Patient'),
                    const SizedBox(height: 10.0),
                    PintigTextField(
                      label: 'Full name (Ngalan sa Inahan)',
                      hint: 'e.g. Maria Clara Santos',
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

                    const PintigSectionTitle('Pregnancy dates'),
                    const SizedBox(height: 10.0),
                    PintigTextField(
                      label: 'Last menstrual period (LMP)',
                      hint: 'Pick the date',
                      controller: _lmpController,
                      readOnly: true,
                      onTap: () => _selectLmpDate(context),
                      suffixIcon: const PintigIcon(PintigIconName.calendar, size: 24.0),
                    ),
                    const SizedBox(height: 14.0),
                    PintigTextField(
                      label: 'Expected delivery date (EDC)',
                      hint: 'Filled in from the LMP',
                      controller: _edcController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 14.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PintigTextField(
                            label: 'Pregnancies (G)',
                            hint: '1 or more',
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.setGravidity(int.tryParse(v) ?? 1),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: PintigTextField(
                            label: 'Births (P)',
                            hint: '0 or more',
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.setParity(int.tryParse(v) ?? 0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26.0),

                    const PintigSectionTitle("Today's readings"),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PintigTextField(
                            label: 'Top number (systolic)',
                            hint: '60 to 260',
                            unit: 'mmHg',
                            controller: _systolicController,
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.updateBloodPressure(systolic: int.tryParse(v)),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: PintigTextField(
                            label: 'Bottom number (diastolic)',
                            hint: '30 to 160',
                            unit: 'mmHg',
                            controller: _diastolicController,
                            keyboardType: TextInputType.number,
                            onChanged: (v) => notifier.updateBloodPressure(diastolic: int.tryParse(v)),
                          ),
                        ),
                      ],
                    ),
                    if (formState.bpValidationError != null) ...[
                      const SizedBox(height: 10.0),
                      PintigCdssBanner(
                        title: 'Check the blood pressure (Dili sakto)',
                        message: formState.bpValidationError!,
                        tone: PintigTone.caution,
                        icon: PintigIconName.info,
                      ),
                    ],
                    const SizedBox(height: 14.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PintigTextField(
                            label: 'Weight',
                            hint: 'Over 20',
                            unit: 'kg',
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => notifier.setWeight(double.tryParse(v)),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: PintigTextField(
                            label: 'Fundic height',
                            hint: 'Optional',
                            unit: 'cm',
                            controller: _fundicController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => notifier.setFundicHeight(double.tryParse(v)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18.0),
                    PintigToggleRow(
                      title: 'Gave iron and folic acid today',
                      subtitle: 'Gihatagan og Iron & Folic Acid karon',
                      value: formState.ironFolicGiven,
                      activeColor: PintigTokens.sea,
                      activeTint: PintigTokens.seaTint,
                      onChanged: notifier.setIronFolic,
                    ),
                  ],
                ),
              ),
            ),
            PintigActionBar(
              banners: [
                if (triage != null)
                  PintigCdssBanner(
                    title: triage.statusBadge,
                    message: triage.clinicalRationale,
                    tone: triageTone,
                    icon: triageTone == PintigTone.ok ? PintigIconName.check : PintigIconName.alert,
                  ),
              ],
              disabledHint: formState.isValid ? null : 'Fill in the required fields to save.',
              button: PintigPrimaryButton(
                label: 'Save visit',
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
