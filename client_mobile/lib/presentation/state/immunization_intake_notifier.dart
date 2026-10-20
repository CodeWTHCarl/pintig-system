// lib/presentation/state/immunization_intake_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database.dart';
import '../../data/repositories/encounter_repository.dart';

class ImmunizationFormState {
  final String patientName;
  final String sitioPurok;
  final String antigenCode;
  final int doseNumber;
  final DateTime administrationDate;
  final String? lotNumber;
  final bool aefiReported;
  final String? aefiSymptoms;
  final String? intervalViolationMessage;
  final bool isSubmitting;
  final String? submissionError;
  final bool isSuccess;

  const ImmunizationFormState({
    this.patientName = '',
    this.sitioPurok = 'Purok 1 (Centro)',
    this.antigenCode = 'BCG',
    this.doseNumber = 1,
    required this.administrationDate,
    this.lotNumber,
    this.aefiReported = false,
    this.aefiSymptoms,
    this.intervalViolationMessage,
    this.isSubmitting = false,
    this.submissionError,
    this.isSuccess = false,
  });

  bool get isValid => patientName.trim().isNotEmpty && intervalViolationMessage == null;

  String get triageRiskLevel => aefiReported ? 'HIGH' : 'NORMAL';

  ImmunizationFormState copyWith({
    String? patientName,
    String? sitioPurok,
    String? antigenCode,
    int? doseNumber,
    DateTime? administrationDate,
    String? lotNumber,
    bool? aefiReported,
    String? aefiSymptoms,
    String? intervalViolationMessage,
    bool clearIntervalError = false,
    bool isSubmitting = false,
    String? submissionError,
    bool isSuccess = false,
  }) {
    return ImmunizationFormState(
      patientName: patientName ?? this.patientName,
      sitioPurok: sitioPurok ?? this.sitioPurok,
      antigenCode: antigenCode ?? this.antigenCode,
      doseNumber: doseNumber ?? this.doseNumber,
      administrationDate: administrationDate ?? this.administrationDate,
      lotNumber: lotNumber ?? this.lotNumber,
      aefiReported: aefiReported ?? this.aefiReported,
      aefiSymptoms: aefiSymptoms ?? this.aefiSymptoms,
      intervalViolationMessage: clearIntervalError
          ? null
          : (intervalViolationMessage ?? this.intervalViolationMessage),
      isSubmitting: isSubmitting,
      submissionError: submissionError,
      isSuccess: isSuccess,
    );
  }
}

class ImmunizationIntakeNotifier extends StateNotifier<ImmunizationFormState> {
  final EncounterRepository _repository;
  final String patientUuid;
  final String bhwUserId;
  final List<ImmunizationDetail> _history;

  ImmunizationIntakeNotifier({
    required EncounterRepository repository,
    required this.patientUuid,
    required this.bhwUserId,
    required List<ImmunizationDetail> history,
  })  : _repository = repository,
        _history = history,
        super(ImmunizationFormState(administrationDate: DateTime.now())) {
    _validateInterval();
  }

  void setPatientName(String name) => state = state.copyWith(patientName: name);
  void setSitioPurok(String sitio) => state = state.copyWith(sitioPurok: sitio);

  void setAntigen(String antigen) {
    state = state.copyWith(antigenCode: antigen);
    _validateInterval();
  }

  void setDoseNumber(int dose) {
    state = state.copyWith(doseNumber: dose);
    _validateInterval();
  }

  void setAdministrationDate(DateTime date) {
    state = state.copyWith(administrationDate: date);
    _validateInterval();
  }

  void setLotNumber(String? lot) {
    state = state.copyWith(lotNumber: lot);
  }

  void setAefiReported(bool value) {
    state = state.copyWith(aefiReported: value);
  }

  void setAefiSymptoms(String? symptoms) {
    state = state.copyWith(aefiSymptoms: symptoms);
  }

  void _validateInterval() {
    if (['PENTA', 'OPV', 'IPV', 'PCV'].contains(state.antigenCode) && state.doseNumber > 1) {
      final prevDoseNumber = state.doseNumber - 1;
      final prevDose = _history
          .where((h) => h.antigenCode == state.antigenCode && h.doseNumber == prevDoseNumber)
          .firstOrNull;

      if (prevDose != null) {
        final prevDate = DateTime.parse(prevDose.administrationDate);
        final difference = state.administrationDate.difference(prevDate).inDays;

        if (difference < 28) {
          state = state.copyWith(
            intervalViolationMessage:
                'Dose ${state.doseNumber} is within $difference days of Dose $prevDoseNumber. EPI requires >= 28 days spacing.',
          );
          return;
        }
      }
    }
    state = state.copyWith(clearIntervalError: true);
  }

  Future<void> submitEncounter() async {
    if (!state.isValid) return;

    state = state.copyWith(isSubmitting: true, submissionError: null);

    try {
      await _repository.commitImmunizationEncounter(
        patientUuid: patientUuid,
        bhwUserId: bhwUserId,
        encounterTimestamp: DateTime.now(),
        antigenCode: state.antigenCode,
        doseNumber: state.doseNumber,
        administrationDate: state.administrationDate.toIso8601String().substring(0, 10),
        lotNumber: state.lotNumber,
        triageRiskLevel: state.triageRiskLevel,
        aefiReported: state.aefiReported,
        aefiNotes: state.aefiSymptoms,
        patientName: state.patientName.trim(),
        sitioPurok: state.sitioPurok,
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