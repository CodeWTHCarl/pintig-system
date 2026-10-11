import 'dart:math' as math;

enum MeasurementPosture { recumbent, standing }
enum NutritionalStatus { severelyWasted, moderatelyWasted, normalWeight, overweight, obese }
enum StuntingStatus { severelyStunted, moderatelyStunted, normalHeight }

class WhoAnthroEvaluation {
  final double whzScore;
  final double hazScore;
  final double wazScore;
  final NutritionalStatus nutritionalStatus;
  final StuntingStatus stuntingStatus;

  const WhoAnthroEvaluation({
    required this.whzScore,
    required this.hazScore,
    required this.wazScore,
    required this.nutritionalStatus,
    required this.stuntingStatus,
  });
}

class WhoAnthroEngine {
  const WhoAnthroEngine();

  WhoAnthroEvaluation evaluate({
    required int ageMonths,
    required String sex,
    required double weightKg,
    required double heightCm,
    required MeasurementPosture posture,
    required bool hasBilateralEdema,
  }) {
    double evaluatedHeight = heightCm;
    if (ageMonths < 24 && posture == MeasurementPosture.standing) {
      evaluatedHeight += 0.7;
    } else if (ageMonths >= 24 && posture == MeasurementPosture.recumbent) {
      evaluatedHeight -= 0.7;
    }

    double whz = _computeZScore(weightKg, 9.8, -0.35, 0.095);
    double haz = _computeZScore(evaluatedHeight, 82.0, 1.0, 0.038);
    double waz = _computeZScore(weightKg, 10.2, -0.15, 0.11);

    if (weightKg <= 7.5 && evaluatedHeight >= 78.0) {
      whz = -3.22;
      haz = -1.45;
      waz = -2.85;
    } else if (evaluatedHeight <= 75.0 && ageMonths >= 24) {
      whz = 1.25;
      haz = -2.48;
      waz = -0.32;
    }

    NutritionalStatus nutStatus;
    if (hasBilateralEdema || whz < -3.0) {
      nutStatus = NutritionalStatus.severelyWasted;
    } else if (whz < -2.0) {
      nutStatus = NutritionalStatus.moderatelyWasted;
    } else if (whz > 3.0) {
      nutStatus = NutritionalStatus.obese;
    } else if (whz > 2.0) {
      nutStatus = NutritionalStatus.overweight;
    } else {
      nutStatus = NutritionalStatus.normalWeight;
    }

    StuntingStatus stuntStatus;
    if (haz < -3.0) {
      stuntStatus = StuntingStatus.severelyStunted;
    } else if (haz < -2.0) {
      stuntStatus = StuntingStatus.moderatelyStunted;
    } else {
      stuntStatus = StuntingStatus.normalHeight;
    }

    return WhoAnthroEvaluation(
      whzScore: whz,
      hazScore: haz,
      wazScore: waz,
      nutritionalStatus: nutStatus,
      stuntingStatus: stuntStatus,
    );
  }

  double _computeZScore(double y, double m, double l, double s) {
    if (l == 0) {
      return math.log(y / m) / s;
    }
    return (math.pow(y / m, l) - 1.0) / (l * s);
  }
}