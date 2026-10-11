// lib/data/repositories/encounter_repository.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

class EncounterRepository {
  final AppDatabase db;
  final Uuid _uuid = const Uuid();

  EncounterRepository(this.db);

  Future<String> commitMaternalCareEncounter({
    required String patientUuid,
    required String bhwUserId,
    required DateTime encounterTimestamp,
    required String triageRiskLevel,
    required String lmpDate,
    required String edcDate,
    required int gravidity,
    required int parity,
    required int systolicBp,
    required int diastolicBp,
    required double maternalWeightKg,
    required double? fundicHeightCm,
    required bool ironFolicGiven,
    String? clinicalNotes,
  }) async {
    final encounterUuid = _uuid.v4();
    final isoTimestamp = encounterTimestamp.toUtc().toIso8601String();

    final clinicalDataPayload = {
      'lmp_date': lmpDate,
      'edc_date': edcDate,
      'gravidity': gravidity,
      'parity': parity,
      'systolic_bp': systolicBp,
      'diastolic_bp': diastolicBp,
      'weight_kg': maternalWeightKg,
      'fundic_height_cm': fundicHeightCm,
      'iron_folic_given': ironFolicGiven,
    };

    final syncEnvelopeEncounter = {
      'encounter_uuid': encounterUuid,
      'patient_uuid': patientUuid,
      'bhw_id': bhwUserId,
      'encounter_type': 'MATERNAL_CARE',
      'timestamp': isoTimestamp,
      'triage_risk_level': triageRiskLevel,
      'clinical_data': clinicalDataPayload,
    };

    await db.transaction(() async {
      await db.into(db.encounters).insert(
            EncountersCompanion(
              encounterUuid: Value(encounterUuid),
              patientUuid: Value(patientUuid),
              bhwUserId: Value(bhwUserId),
              encounterType: const Value('MATERNAL_CARE'),
              encounterTimestamp: Value(isoTimestamp),
              triageRiskLevel: Value(triageRiskLevel),
              clinicalNotes: Value(clinicalNotes),
              createdAt: Value(isoTimestamp),
            ),
          );

      await db.into(db.maternalCareDetails).insert(
            MaternalCareDetailsCompanion(
              encounterUuid: Value(encounterUuid),
              lmpDate: Value(lmpDate),
              edcDate: Value(edcDate),
              gravidity: Value(gravidity),
              parity: Value(parity),
              systolicBp: Value(systolicBp),
              diastolicBp: Value(diastolicBp),
              maternalWeightKg: Value(maternalWeightKg),
              fundicHeightCm: Value(fundicHeightCm),
              ironFolicGiven: Value(ironFolicGiven ? 1 : 0),
            ),
          );

      await db.into(db.syncQueue).insert(
            SyncQueueCompanion(
              entityUuid: Value(encounterUuid),
              entityType: const Value('ENCOUNTER'),
              operationType: const Value('INSERT'),
              payloadJson: Value(jsonEncode(syncEnvelopeEncounter)),
              syncStatus: const Value('PENDING'),
              retryCount: const Value(0),
              createdAt: Value(isoTimestamp),
            ),
          );
    });

    return encounterUuid;
  }

  Future<String> commitOptNutritionEncounter({
    required String patientUuid,
    required String bhwUserId,
    required DateTime encounterTimestamp,
    required String triageRiskLevel,
    required int ageMonths,
    required double weightKg,
    required double heightCm,
    required String posture,
    required bool edema,
    required double whzScore,
    required double hazScore,
    required double wazScore,
    required String nutritionalStatus,
    String? clinicalNotes,
  }) async {
    final encounterUuid = _uuid.v4();
    final isoTimestamp = encounterTimestamp.toUtc().toIso8601String();

    final clinicalDataPayload = {
      'age_months': ageMonths,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'posture': posture,
      'edema': edema,
      'whz': whzScore,
      'haz': hazScore,
      'waz': wazScore,
      'nutritional_status': nutritionalStatus,
    };

    final syncEnvelopeEncounter = {
      'encounter_uuid': encounterUuid,
      'patient_uuid': patientUuid,
      'bhw_id': bhwUserId,
      'encounter_type': 'NUTRITION_OPT',
      'timestamp': isoTimestamp,
      'triage_risk_level': triageRiskLevel,
      'clinical_data': clinicalDataPayload,
    };

    await db.transaction(() async {
      await db.into(db.encounters).insert(
            EncountersCompanion(
              encounterUuid: Value(encounterUuid),
              patientUuid: Value(patientUuid),
              bhwUserId: Value(bhwUserId),
              encounterType: const Value('NUTRITION_OPT'),
              encounterTimestamp: Value(isoTimestamp),
              triageRiskLevel: Value(triageRiskLevel),
              clinicalNotes: Value(clinicalNotes),
              createdAt: Value(isoTimestamp),
            ),
          );

      await db.into(db.nutritionLogs).insert(
            NutritionLogsCompanion(
              encounterUuid: Value(encounterUuid),
              ageMonths: Value(ageMonths),
              weightKg: Value(weightKg),
              heightCm: Value(heightCm),
              posture: Value(posture),
              edema: Value(edema ? 1 : 0),
              whzScore: Value(whzScore),
              hazScore: Value(hazScore),
              wazScore: Value(wazScore),
              nutritionalStatus: Value(nutritionalStatus),
            ),
          );

      await db.into(db.syncQueue).insert(
            SyncQueueCompanion(
              entityUuid: Value(encounterUuid),
              entityType: const Value('ENCOUNTER'),
              operationType: const Value('INSERT'),
              payloadJson: Value(jsonEncode(syncEnvelopeEncounter)),
              syncStatus: const Value('PENDING'),
              retryCount: const Value(0),
              createdAt: Value(isoTimestamp),
            ),
          );
    });

    return encounterUuid;
  }

  Future<String> commitImmunizationEncounter({
    required String patientUuid,
    required String bhwUserId,
    required DateTime encounterTimestamp,
    required String antigenCode,
    required int doseNumber,
    required String administrationDate,
    required String? lotNumber,
    String? clinicalNotes,
  }) async {
    final encounterUuid = _uuid.v4();
    final isoTimestamp = encounterTimestamp.toUtc().toIso8601String();

    final clinicalDataPayload = {
      'antigen_code': antigenCode,
      'dose_number': doseNumber,
      'administration_date': administrationDate,
      'lot_number': lotNumber,
    };

    final syncEnvelopeEncounter = {
      'encounter_uuid': encounterUuid,
      'patient_uuid': patientUuid,
      'bhw_id': bhwUserId,
      'encounter_type': 'IMMUNIZATION',
      'timestamp': isoTimestamp,
      'triage_risk_level': 'NORMAL',
      'clinical_data': clinicalDataPayload,
    };

    await db.transaction(() async {
      await db.into(db.encounters).insert(
            EncountersCompanion(
              encounterUuid: Value(encounterUuid),
              patientUuid: Value(patientUuid),
              bhwUserId: Value(bhwUserId),
              encounterType: const Value('IMMUNIZATION'),
              encounterTimestamp: Value(isoTimestamp),
              triageRiskLevel: const Value('NORMAL'),
              clinicalNotes: Value(clinicalNotes),
              createdAt: Value(isoTimestamp),
            ),
          );

      await db.into(db.immunizationDetails).insert(
            ImmunizationDetailsCompanion(
              encounterUuid: Value(encounterUuid),
              antigenCode: Value(antigenCode),
              doseNumber: Value(doseNumber),
              administrationDate: Value(administrationDate),
              lotNumber: Value(lotNumber),
            ),
          );

      await db.into(db.syncQueue).insert(
            SyncQueueCompanion(
              entityUuid: Value(encounterUuid),
              entityType: const Value('ENCOUNTER'),
              operationType: const Value('INSERT'),
              payloadJson: Value(jsonEncode(syncEnvelopeEncounter)),
              syncStatus: const Value('PENDING'),
              retryCount: const Value(0),
              createdAt: Value(isoTimestamp),
            ),
          );
    });

    return encounterUuid;
  }

  Future<List<ImmunizationDetail>> getPatientImmunizationHistory(String patientUuid) async {
    final query = db.select(db.immunizationDetails).join([
      innerJoin(
        db.encounters,
        db.encounters.encounterUuid.equalsExp(db.immunizationDetails.encounterUuid),
      ),
    ])..where(db.encounters.patientUuid.equals(patientUuid));

    final rows = await query.get();
    return rows.map((row) => row.readTable(db.immunizationDetails)).toList();
  }
}