// lib/presentation/state/opt_intake_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/encounter_repository.dart';
import '../../domain/cdss/who_anthro_engine.dart';

class OptFormState {
  final String patientName;
  final String sitioPurok;
  final String sex;
  final DateTime birthdate;
  final DateTime measurementDate;
  final int ageMonths;
  final double? weightKg;
  final double? heightCm;
  final MeasurementPosture posture;
  final bool hasEdema;
  final WhoAnthroEvaluation? anthroEvaluation;
  final bool isSubmitting;
  final String? submissionError;
  final bool isSuccess;

  const OptFormState({
    this.patientName = '',
    this.sitioPurok = 'Purok 1 (Centro)',
    this.sex = 'M',
    required this.birthdate,
    required this.measurementDate,
    required this.ageMonths,
    this.weightKg,
    this.heightCm,
    this.posture = MeasurementPosture.recumbent,
    this.hasEdema = false,
    this.anthroEvaluation,
    this.isSubmitting = false,
    this.submissionError,
    this.isSuccess = false,
  });

  bool get isValid =>
      patientName.trim().isNotEmpty &&
      weightKg != null &&
      weightKg! > 0 &&
      heightCm != null &&
      heightCm! > 0 &&
      ageMonths >= 0 &&
      ageMonths <= 59 &&
      anthroEvaluation != null;

  OptFormState copyWith({
    String? patientName,
    String? sitioPurok,
    String? sex,
    DateTime? birthdate,
    DateTime? measurementDate,
    int? ageMonths,
    double? weightKg,
    double? heightCm,
    MeasurementPosture? posture,
    bool? hasEdema,
    WhoAnthroEvaluation? anthroEvaluation,
    bool isSubmitting = false,
    String? submissionError,
    bool isSuccess = false,
  }) {
    return OptFormState(
      patientName: patientName ?? this.patientName,
      sitioPurok: sitioPurok ?? this.sitioPurok,
      sex: sex ?? this.sex,
      birthdate: birthdate ?? this.birthdate,
      measurementDate: measurementDate ?? this.measurementDate,
      ageMonths: ageMonths ?? this.ageMonths,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      posture: posture ?? this.posture,
      hasEdema: hasEdema ?? this.hasEdema,
      anthroEvaluation: anthroEvaluation ?? this.anthroEvaluation,
      isSubmitting: isSubmitting,
      submissionError: submissionError,
      isSuccess: isSuccess,
    );
  }
}

class OptIntakeNotifier extends StateNotifier<OptFormState> {
  final EncounterRepository _repository;
  final WhoAnthroEngine _anthroEngine;
  final String patientUuid;
  final String bhwUserId;

  OptIntakeNotifier({
    required EncounterRepository repository,
    WhoAnthroEngine? anthroEngine,
    required this.patientUuid,
    required String patientSex,
    required this.bhwUserId,
    required DateTime initialBirthdate,
  })  : _repository = repository,
        _anthroEngine = anthroEngine ?? const WhoAnthroEngine(),
        super(
          OptFormState(
            sex: patientSex,
            birthdate: initialBirthdate,
            measurementDate: DateTime.now(),
            ageMonths: _computeMonths(initialBirthdate, DateTime.now()),
            posture: _computeMonths(initialBirthdate, DateTime.now()) < 24
                ? MeasurementPosture.recumbent
                : MeasurementPosture.standing,
          ),
        );

  static int _computeMonths(DateTime birthdate, DateTime target) {
    final days = target.difference(birthdate).inDays;
    return (days / 30.4375).floor().clamp(0, 59);
  }

  void setPatientName(String name) => state = state.copyWith(patientName: name);
  void setSitioPurok(String sitio) => state = state.copyWith(sitioPurok: sitio);

  void setAgeMonths(int months) {
    final clamped = months.clamp(0, 59);
    final autoPosture = clamped < 24 ? MeasurementPosture.recumbent : MeasurementPosture.standing;
    state = state.copyWith(ageMonths: clamped, posture: autoPosture);
    _recalculateAnthro();
  }

  void setSex(String sex) {
    state = state.copyWith(sex: sex);
    _recalculateAnthro();
  }

  void setWeight(double? weight) {
    state = state.copyWith(weightKg: weight);
    _recalculateAnthro();
  }

  void setHeight(double? height) {
    state = state.copyWith(heightCm: height);
    _recalculateAnthro();
  }

  void setPosture(MeasurementPosture posture) {
    state = state.copyWith(posture: posture);
    _recalculateAnthro();
  }

  void setEdema(bool edema) {
    state = state.copyWith(hasEdema: edema);
    _recalculateAnthro();
  }

  void _recalculateAnthro() {
    if (state.weightKg == null || state.heightCm == null) {
      state = state.copyWith(anthroEvaluation: null);
      return;
    }

    try {
      final eval = _anthroEngine.evaluate(
        ageMonths: state.ageMonths,
        sex: state.sex,
        weightKg: state.weightKg!,
        heightCm: state.heightCm!,
        posture: state.posture,
        hasBilateralEdema: state.hasEdema,
      );
      state = state.copyWith(anthroEvaluation: eval);
    } catch (_) {
      state = state.copyWith(anthroEvaluation: null);
    }
  }

  Future<void> submitEncounter() async {
    if (!state.isValid) return;

    state = state.copyWith(isSubmitting: true, submissionError: null);

    try {
      final triageRisk = switch (state.anthroEvaluation!.nutritionalStatus) {
        NutritionalStatus.severelyWasted => 'HIGH',
        NutritionalStatus.moderatelyWasted => 'MODERATE',
        _ => (state.anthroEvaluation!.stuntingStatus == StuntingStatus.severelyStunted
            ? 'HIGH'
            : (state.anthroEvaluation!.stuntingStatus == StuntingStatus.moderatelyStunted
                ? 'MODERATE'
                : 'NORMAL')),
      };

      final statusString = switch (state.anthroEvaluation!.nutritionalStatus) {
        NutritionalStatus.severelyWasted => 'SEVERELY_WASTED',
        NutritionalStatus.moderatelyWasted => 'MODERATELY_WASTED',
        NutritionalStatus.overweight => 'OVERWEIGHT',
        NutritionalStatus.obese => 'OBESE',
        NutritionalStatus.normalWeight => 'NORMAL',
      };

      await _repository.commitOptNutritionEncounter(
        patientUuid: patientUuid,
        bhwUserId: bhwUserId,
        encounterTimestamp: DateTime.now(),
        triageRiskLevel: triageRisk,
        ageMonths: state.ageMonths,
        weightKg: state.weightKg!,
        heightCm: state.heightCm!,
        posture: state.posture == MeasurementPosture.recumbent ? 'RECUMBENT' : 'STANDING',
        edema: state.hasEdema,
        whzScore: state.anthroEvaluation!.whzScore,
        hazScore: state.anthroEvaluation!.hazScore,
        wazScore: state.anthroEvaluation!.wazScore,
        nutritionalStatus: statusString,
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