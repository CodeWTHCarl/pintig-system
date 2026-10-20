// lib/presentation/screens/maternal_intake_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/cdss/maternal_triage_engine.dart';
import '../state/maternal_intake_notifier.dart';
import '../theme/pintig_tokens.dart';
import '../widgets/accessible_form_widgets.dart';

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
            content: Text('Encounter committed & queued for sync successfully (<=100ms)'),
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
        title: const Text('Maternal Intake (TCL-MC)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: PintigTokens.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Deterministic CDSS Alert Banner
            if (formState.triageResult != null) ...[
              PintigCdssBanner(
                title: formState.triageResult!.statusBadge,
                message: formState.triageResult!.clinicalRationale,
                backgroundColor: formState.triageResult!.riskLevel == TriageRiskLevel.high
                    ? PintigTokens.clinicalRed
                    : (formState.triageResult!.riskLevel == TriageRiskLevel.normal
                        ? PintigTokens.clinicalGreen
                        : PintigTokens.clinicalAmber),
                icon: formState.triageResult!.riskLevel == TriageRiskLevel.high
                    ? Icons.warning_rounded
                    : Icons.check_circle_outline,
              ),
              const SizedBox(height: 16.0),
            ],

            if (formState.bpValidationError != null) ...[
              PintigCdssBanner(
                title: 'BP Entry Error / Dili Sakto',
                message: formState.bpValidationError!,
                backgroundColor: PintigTokens.clinicalAmber,
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 16.0),
            ],

            // Patient Demographic Identification
            PintigTextField(
              label: 'Patient Full Name (Ngalan sa Inahan) *',
              hint: 'e.g. Maria Clara Santos',
              controller: _nameController,
              onChanged: notifier.setPatientName,
            ),
            const SizedBox(height: 14.0),

            const Text(
              'Sitio / Purok Location (Brgy. P.I. Garcia) *',
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6.0),
            DropdownButtonFormField<String>(
              value: formState.sitioPurok,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(PintigTokens.inputRadius),
                ),
              ),
              items: _sitioOptions
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (val) {
                if (val != null) notifier.setSitioPurok(val);
              },
            ),
            const SizedBox(height: 14.0),

            // Obstetric Dates Section
            PintigTextField(
              label: 'Last Menstrual Period (LMP) *',
              hint: 'Select LMP Date',
              controller: _lmpController,
              readOnly: true,
              onTap: () => _selectLmpDate(context),
              suffixIcon: const Icon(Icons.calendar_today, color: PintigTokens.primaryBlue),
            ),
            const SizedBox(height: 14.0),

            PintigTextField(
              label: 'Estimated Date of Confinement (EDC) [Auto-Derived]',
              hint: 'Auto-calculated via Naegele Rule',
              controller: _edcController,
              readOnly: true,
            ),
            const SizedBox(height: 14.0),

            Row(
              children: [
                Expanded(
                  child: PintigTextField(
                    label: 'Gravidity (G) *',
                    hint: '>= 1',
                    keyboardType: TextInputType.number,
                    onChanged: (v) => notifier.setGravidity(int.tryParse(v) ?? 1),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: PintigTextField(
                    label: 'Parity (P) *',
                    hint: '>= 0',
                    keyboardType: TextInputType.number,
                    onChanged: (v) => notifier.setParity(int.tryParse(v) ?? 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // Hemodynamics Section
            Row(
              children: [
                Expanded(
                  child: PintigTextField(
                    label: 'Systolic BP (mmHg) *',
                    hint: '60 - 260',
                    controller: _systolicController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => notifier.updateBloodPressure(systolic: int.tryParse(v)),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: PintigTextField(
                    label: 'Diastolic BP (mmHg) *',
                    hint: '30 - 160',
                    controller: _diastolicController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => notifier.updateBloodPressure(diastolic: int.tryParse(v)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14.0),

            // Physical Parameters
            Row(
              children: [
                Expanded(
                  child: PintigTextField(
                    label: 'Weight (kg) *',
                    hint: '> 20.0',
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => notifier.setWeight(double.tryParse(v)),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: PintigTextField(
                    label: 'Fundic Height (cm)',
                    hint: 'Optional',
                    controller: _fundicController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => notifier.setFundicHeight(double.tryParse(v)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Micronutrient Supplementation Switch
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(PintigTokens.inputRadius),
                border: Border.all(color: PintigTokens.cardBorder),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Iron & Folic Acid Given',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                subtitle: const Text('Gihatagan og Iron & Folic Acid karon'),
                value: formState.ironFolicGiven,
                activeColor: PintigTokens.primaryBlue,
                onChanged: notifier.setIronFolic,
              ),
            ),
            const SizedBox(height: 24.0),

            // Transaction Submit Button
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