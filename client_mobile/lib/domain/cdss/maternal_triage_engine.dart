enum TriageRiskLevel { normal, moderate, high }

class MaternalValidationException implements Exception {
  final String message;
  const MaternalValidationException(this.message);
  @override
  String toString() => message;
}

class MaternalTriageResult {
  final TriageRiskLevel riskLevel;
  final String statusBadge;
  final String clinicalRationale;

  const MaternalTriageResult({
    required this.riskLevel,
    required this.statusBadge,
    required this.clinicalRationale,
  });
}

class MaternalTriageEngine {
  static MaternalTriageResult evaluate({
    required int systolic,
    required int diastolic,
  }) {
    if (systolic < 60 || systolic > 260) {
      throw const MaternalValidationException('Systolic BP must be between 60 and 260 mmHg.');
    }
    if (diastolic < 30 || diastolic > 160) {
      throw const MaternalValidationException('Diastolic BP must be between 30 and 160 mmHg.');
    }
    if (diastolic >= systolic) {
      throw const MaternalValidationException('Diastolic pressure cannot exceed or equal systolic pressure.');
    }
    if ((systolic - diastolic) < 15) {
      throw const MaternalValidationException('Pulse pressure (Systolic - Diastolic) must be at least 15 mmHg.');
    }

    if (systolic >= 140 || diastolic >= 90) {
      return const MaternalTriageResult(
        riskLevel: TriageRiskLevel.high,
        statusBadge: 'High Risk: Possible Preeclampsia',
        clinicalRationale: 'Blood pressure exceeds 140/90 mmHg. Immediate midwife or MHO referral required.',
      );
    }

    if (systolic < 90 || diastolic < 60) {
      return const MaternalTriageResult(
        riskLevel: TriageRiskLevel.moderate,
        statusBadge: 'Moderate: Maternal Hypotension',
        clinicalRationale: 'Blood pressure below standard range. Monitor hydration and maternal status.',
      );
    }

    return const MaternalTriageResult(
      riskLevel: TriageRiskLevel.normal,
      statusBadge: 'Vitals Within Normal Limits',
      clinicalRationale: 'Normotensive prenatal vitals recorded.',
    );
  }
}