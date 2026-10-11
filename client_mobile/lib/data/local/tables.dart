import 'package:drift/drift.dart';

class Households extends Table {
  TextColumn get householdUuid => text()();
  TextColumn get sitioName => text()();
  TextColumn get dwellingType => text()();
  IntColumn get waterSourceCode => integer()();
  IntColumn get sanitationFacilityCode => integer()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {householdUuid};
}

class Patients extends Table {
  TextColumn get patientUuid => text()();
  TextColumn get householdUuid => text().references(Households, #householdUuid)();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get birthdate => text()();
  TextColumn get sex => text()();
  TextColumn get philhealthId => text().nullable()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {patientUuid};
}

class Encounters extends Table {
  TextColumn get encounterUuid => text()();
  TextColumn get patientUuid => text().references(Patients, #patientUuid)();
  TextColumn get bhwUserId => text()();
  TextColumn get encounterType => text()();
  TextColumn get encounterTimestamp => text()();
  TextColumn get triageRiskLevel => text()();
  TextColumn get clinicalNotes => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {encounterUuid};
}

class MaternalCareDetails extends Table {
  TextColumn get encounterUuid => text().references(Encounters, #encounterUuid)();
  TextColumn get lmpDate => text()();
  TextColumn get edcDate => text()();
  IntColumn get gravidity => integer()();
  IntColumn get parity => integer()();
  IntColumn get systolicBp => integer()();
  IntColumn get diastolicBp => integer()();
  RealColumn get maternalWeightKg => real()();
  RealColumn get fundicHeightCm => real().nullable()();
  IntColumn get ironFolicGiven => integer()();

  @override
  Set<Column> get primaryKey => {encounterUuid};
}

class ImmunizationDetails extends Table {
  TextColumn get encounterUuid => text().references(Encounters, #encounterUuid)();
  TextColumn get antigenCode => text()();
  IntColumn get doseNumber => integer()();
  TextColumn get administrationDate => text()();
  TextColumn get lotNumber => text().nullable()();

  @override
  Set<Column> get primaryKey => {encounterUuid};
}

class NutritionLogs extends Table {
  TextColumn get encounterUuid => text().references(Encounters, #encounterUuid)();
  IntColumn get ageMonths => integer()();
  RealColumn get weightKg => real()();
  RealColumn get heightCm => real()();
  TextColumn get posture => text()();
  IntColumn get edema => integer()();
  RealColumn get whzScore => real()();
  RealColumn get hazScore => real()();
  RealColumn get wazScore => real()();
  TextColumn get nutritionalStatus => text()();

  @override
  Set<Column> get primaryKey => {encounterUuid};
}

class SyncQueue extends Table {
  IntColumn get queueId => integer().autoIncrement()();
  TextColumn get entityUuid => text()();
  TextColumn get entityType => text()();
  TextColumn get operationType => text()();
  TextColumn get payloadJson => text()();
  TextColumn get syncStatus => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get createdAt => text()();
  TextColumn get syncedAt => text().nullable()();
}