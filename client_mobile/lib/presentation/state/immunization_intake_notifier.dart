// lib/presentation/state/immunization_intake_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database.dart';
import '../../data/repositories/encounter_repository.dart';

class ImmunizationFormState {
  final String antigenCode;
  final int doseNumber;
  final DateTime administrationDate;
  final String? lotNumber;
  final String? intervalViolationMessage;
  final bool isSubmitting;
  final String? submissionError;
  final bool isSuccess;

  const ImmunizationFormState({
    this.antigenCode = 'BCG',
    this.doseNumber = 1,
    required this.administrationDate,
    this.lotNumber,
    this.intervalViolationMessage,
    this.isSubmitting = false,
    this.submissionError,
    this.isSuccess = false,
  });

  bool get isValid => intervalViolationMessage == null;

  ImmunizationFormState copyWith({
    String? antigenCode,
    int? doseNumber,
    DateTime? administrationDate,
    String? lotNumber,
    String? intervalViolationMessage,
    bool clearIntervalError = false,
    bool isSubmitting = false,
    String? submissionError,
    bool isSuccess = false,
  }) {
    return ImmunizationFormState(
      antigenCode: antigenCode ?? this.antigenCode,
      doseNumber: doseNumber ?? this.doseNumber,
      administrationDate: administrationDate ?? this.administrationDate,
      lotNumber: lotNumber ?? this.lotNumber,
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

  void _validateInterval() {
    // 28-day spacing rule for multidose vaccines: PENTA, OPV, IPV, PCV
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