// lib/presentation/state/maternal_intake_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/encounter_repository.dart';
import '../../domain/cdss/maternal_triage_engine.dart';

class MaternalCareFormState {
  final DateTime? lmpDate;
  final DateTime? edcDate;
  final int gravidity;
  final int parity;
  final int? systolicBp;
  final int? diastolicBp;
  final double? weightKg;
  final double? fundicHeightCm;
  final bool ironFolicGiven;
  final MaternalTriageResult? triageResult;
  final String? bpValidationError;
  final bool isSubmitting;
  final String? submissionError;
  final bool isSuccess;

  const MaternalCareFormState({
    this.lmpDate,
    this.edcDate,
    this.gravidity = 1,
    this.parity = 0,
    this.systolicBp,
    this.diastolicBp,
    this.weightKg,
    this.fundicHeightCm,
    this.ironFolicGiven = true,
    this.triageResult,
    this.bpValidationError,
    this.isSubmitting = false,
    this.submissionError,
    this.isSuccess = false,
  });

  bool get isValid =>
      lmpDate != null &&
      edcDate != null &&
      gravidity >= 1 &&
      parity >= 0 &&
      systolicBp != null &&
      diastolicBp != null &&
      bpValidationError == null &&
      weightKg != null &&
      weightKg! > 20.0;

  MaternalCareFormState copyWith({
    DateTime? lmpDate,
    DateTime? edcDate,
    int? gravidity,
    int? parity,
    int? systolicBp,
    int? diastolicBp,
    double? weightKg,
    double? fundicHeightCm,
    bool? ironFolicGiven,
    MaternalTriageResult? triageResult,
    String? bpValidationError,
    bool clearBpError = false,
    bool isSubmitting = false,
    String? submissionError,
    bool isSuccess = false,
  }) {
    return MaternalCareFormState(
      lmpDate: lmpDate ?? this.lmpDate,
      edcDate: edcDate ?? this.edcDate,
      gravidity: gravidity ?? this.gravidity,
      parity: parity ?? this.parity,
      systolicBp: systolicBp ?? this.systolicBp,
      diastolicBp: diastolicBp ?? this.diastolicBp,
      weightKg: weightKg ?? this.weightKg,
      fundicHeightCm: fundicHeightCm ?? this.fundicHeightCm,
      ironFolicGiven: ironFolicGiven ?? this.ironFolicGiven,
      triageResult: triageResult ?? this.triageResult,
      bpValidationError: clearBpError ? null : (bpValidationError ?? this.bpValidationError),
      isSubmitting: isSubmitting,
      submissionError: submissionError,
      isSuccess: isSuccess,
    );
  }
}

class MaternalIntakeNotifier extends StateNotifier<MaternalCareFormState> {
  final EncounterRepository _repository;
  final String patientUuid;
  final String bhwUserId;

  MaternalIntakeNotifier({
    required EncounterRepository repository,
    required this.patientUuid,
    required this.bhwUserId,
  })  : _repository = repository,
        super(const MaternalCareFormState());

  void setLmpDate(DateTime date) {
    // Naegele's Rule: EDC = LMP + 280 days
    final derivedEdc = date.add(const Duration(days: 280));
    state = state.copyWith(lmpDate: date, edcDate: derivedEdc);
  }

  void setGravidity(int value) => state = state.copyWith(gravidity: value);
  void setParity(int value) => state = state.copyWith(parity: value);
  void setWeight(double? value) => state = state.copyWith(weightKg: value);
  void setFundicHeight(double? value) => state = state.copyWith(fundicHeightCm: value);
  void setIronFolic(bool value) => state = state.copyWith(ironFolicGiven: value);

  void updateBloodPressure({int? systolic, int? diastolic}) {
    final newSys = systolic ?? state.systolicBp;
    final newDia = diastolic ?? state.diastolicBp;

    if (newSys == null || newDia == null) {
      state = state.copyWith(
        systolicBp: newSys,
        diastolicBp: newDia,
        clearBpError: true,
        triageResult: null,
      );
      return;
    }

    try {
      final triage = MaternalTriageEngine.evaluate(systolic: newSys, diastolic: newDia);
      state = state.copyWith(
        systolicBp: newSys,
        diastolicBp: newDia,
        triageResult: triage,
        clearBpError: true,
      );
    } on MaternalValidationException catch (e) {
      state = state.copyWith(
        systolicBp: newSys,
        diastolicBp: newDia,
        bpValidationError: e.message,
        triageResult: null,
      );
    } catch (_) {
      state = state.copyWith(
        systolicBp: newSys,
        diastolicBp: newDia,
        bpValidationError: 'Invalid BP physiological values.',
        triageResult: null,
      );
    }
  }

  Future<void> submitEncounter() async {
    if (!state.isValid) return;

    state = state.copyWith(isSubmitting: true, submissionError: null);

    try {
      final triageString = switch (state.triageResult?.riskLevel) {
        TriageRiskLevel.high => 'HIGH',
        TriageRiskLevel.moderate => 'MODERATE',
        _ => 'NORMAL',
      };

      await _repository.commitMaternalCareEncounter(
        patientUuid: patientUuid,
        bhwUserId: bhwUserId,
        encounterTimestamp: DateTime.now(),
        triageRiskLevel: triageString,
        lmpDate: state.lmpDate!.toIso8601String().substring(0, 10),
        edcDate: state.edcDate!.toIso8601String().substring(0, 10),
        gravidity: state.gravidity,
        parity: state.parity,
        systolicBp: state.systolicBp!,
        diastolicBp: state.diastolicBp!,
        maternalWeightKg: state.weightKg!,
        fundicHeightCm: state.fundicHeightCm,
        ironFolicGiven: state.ironFolicGiven,
      );

      state = state.copyWith(isSubmitting: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        submissionError: 'Transaction failed: ${e.toString()}',
      );
    }
  }
}