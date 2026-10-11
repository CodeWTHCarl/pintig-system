// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $HouseholdsTable extends Households
    with TableInfo<$HouseholdsTable, Household> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HouseholdsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _householdUuidMeta =
      const VerificationMeta('householdUuid');
  @override
  late final GeneratedColumn<String> householdUuid = GeneratedColumn<String>(
      'household_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sitioNameMeta =
      const VerificationMeta('sitioName');
  @override
  late final GeneratedColumn<String> sitioName = GeneratedColumn<String>(
      'sitio_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dwellingTypeMeta =
      const VerificationMeta('dwellingType');
  @override
  late final GeneratedColumn<String> dwellingType = GeneratedColumn<String>(
      'dwelling_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _waterSourceCodeMeta =
      const VerificationMeta('waterSourceCode');
  @override
  late final GeneratedColumn<int> waterSourceCode = GeneratedColumn<int>(
      'water_source_code', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sanitationFacilityCodeMeta =
      const VerificationMeta('sanitationFacilityCode');
  @override
  late final GeneratedColumn<int> sanitationFacilityCode = GeneratedColumn<int>(
      'sanitation_facility_code', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        householdUuid,
        sitioName,
        dwellingType,
        waterSourceCode,
        sanitationFacilityCode,
        latitude,
        longitude,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'households';
  @override
  VerificationContext validateIntegrity(Insertable<Household> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('household_uuid')) {
      context.handle(
          _householdUuidMeta,
          householdUuid.isAcceptableOrUnknown(
              data['household_uuid']!, _householdUuidMeta));
    } else if (isInserting) {
      context.missing(_householdUuidMeta);
    }
    if (data.containsKey('sitio_name')) {
      context.handle(_sitioNameMeta,
          sitioName.isAcceptableOrUnknown(data['sitio_name']!, _sitioNameMeta));
    } else if (isInserting) {
      context.missing(_sitioNameMeta);
    }
    if (data.containsKey('dwelling_type')) {
      context.handle(
          _dwellingTypeMeta,
          dwellingType.isAcceptableOrUnknown(
              data['dwelling_type']!, _dwellingTypeMeta));
    } else if (isInserting) {
      context.missing(_dwellingTypeMeta);
    }
    if (data.containsKey('water_source_code')) {
      context.handle(
          _waterSourceCodeMeta,
          waterSourceCode.isAcceptableOrUnknown(
              data['water_source_code']!, _waterSourceCodeMeta));
    } else if (isInserting) {
      context.missing(_waterSourceCodeMeta);
    }
    if (data.containsKey('sanitation_facility_code')) {
      context.handle(
          _sanitationFacilityCodeMeta,
          sanitationFacilityCode.isAcceptableOrUnknown(
              data['sanitation_facility_code']!, _sanitationFacilityCodeMeta));
    } else if (isInserting) {
      context.missing(_sanitationFacilityCodeMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {householdUuid};
  @override
  Household map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Household(
      householdUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_uuid'])!,
      sitioName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sitio_name'])!,
      dwellingType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dwelling_type'])!,
      waterSourceCode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}water_source_code'])!,
      sanitationFacilityCode: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}sanitation_facility_code'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HouseholdsTable createAlias(String alias) {
    return $HouseholdsTable(attachedDatabase, alias);
  }
}

class Household extends DataClass implements Insertable<Household> {
  final String householdUuid;
  final String sitioName;
  final String dwellingType;
  final int waterSourceCode;
  final int sanitationFacilityCode;
  final double? latitude;
  final double? longitude;
  final String createdAt;
  final String updatedAt;
  const Household(
      {required this.householdUuid,
      required this.sitioName,
      required this.dwellingType,
      required this.waterSourceCode,
      required this.sanitationFacilityCode,
      this.latitude,
      this.longitude,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['household_uuid'] = Variable<String>(householdUuid);
    map['sitio_name'] = Variable<String>(sitioName);
    map['dwelling_type'] = Variable<String>(dwellingType);
    map['water_source_code'] = Variable<int>(waterSourceCode);
    map['sanitation_facility_code'] = Variable<int>(sanitationFacilityCode);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  HouseholdsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdsCompanion(
      householdUuid: Value(householdUuid),
      sitioName: Value(sitioName),
      dwellingType: Value(dwellingType),
      waterSourceCode: Value(waterSourceCode),
      sanitationFacilityCode: Value(sanitationFacilityCode),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Household.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Household(
      householdUuid: serializer.fromJson<String>(json['householdUuid']),
      sitioName: serializer.fromJson<String>(json['sitioName']),
      dwellingType: serializer.fromJson<String>(json['dwellingType']),
      waterSourceCode: serializer.fromJson<int>(json['waterSourceCode']),
      sanitationFacilityCode:
          serializer.fromJson<int>(json['sanitationFacilityCode']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'householdUuid': serializer.toJson<String>(householdUuid),
      'sitioName': serializer.toJson<String>(sitioName),
      'dwellingType': serializer.toJson<String>(dwellingType),
      'waterSourceCode': serializer.toJson<int>(waterSourceCode),
      'sanitationFacilityCode': serializer.toJson<int>(sanitationFacilityCode),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Household copyWith(
          {String? householdUuid,
          String? sitioName,
          String? dwellingType,
          int? waterSourceCode,
          int? sanitationFacilityCode,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          String? createdAt,
          String? updatedAt}) =>
      Household(
        householdUuid: householdUuid ?? this.householdUuid,
        sitioName: sitioName ?? this.sitioName,
        dwellingType: dwellingType ?? this.dwellingType,
        waterSourceCode: waterSourceCode ?? this.waterSourceCode,
        sanitationFacilityCode:
            sanitationFacilityCode ?? this.sanitationFacilityCode,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Household copyWithCompanion(HouseholdsCompanion data) {
    return Household(
      householdUuid: data.householdUuid.present
          ? data.householdUuid.value
          : this.householdUuid,
      sitioName: data.sitioName.present ? data.sitioName.value : this.sitioName,
      dwellingType: data.dwellingType.present
          ? data.dwellingType.value
          : this.dwellingType,
      waterSourceCode: data.waterSourceCode.present
          ? data.waterSourceCode.value
          : this.waterSourceCode,
      sanitationFacilityCode: data.sanitationFacilityCode.present
          ? data.sanitationFacilityCode.value
          : this.sanitationFacilityCode,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Household(')
          ..write('householdUuid: $householdUuid, ')
          ..write('sitioName: $sitioName, ')
          ..write('dwellingType: $dwellingType, ')
          ..write('waterSourceCode: $waterSourceCode, ')
          ..write('sanitationFacilityCode: $sanitationFacilityCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      householdUuid,
      sitioName,
      dwellingType,
      waterSourceCode,
      sanitationFacilityCode,
      latitude,
      longitude,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Household &&
          other.householdUuid == this.householdUuid &&
          other.sitioName == this.sitioName &&
          other.dwellingType == this.dwellingType &&
          other.waterSourceCode == this.waterSourceCode &&
          other.sanitationFacilityCode == this.sanitationFacilityCode &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HouseholdsCompanion extends UpdateCompanion<Household> {
  final Value<String> householdUuid;
  final Value<String> sitioName;
  final Value<String> dwellingType;
  final Value<int> waterSourceCode;
  final Value<int> sanitationFacilityCode;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const HouseholdsCompanion({
    this.householdUuid = const Value.absent(),
    this.sitioName = const Value.absent(),
    this.dwellingType = const Value.absent(),
    this.waterSourceCode = const Value.absent(),
    this.sanitationFacilityCode = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdsCompanion.insert({
    required String householdUuid,
    required String sitioName,
    required String dwellingType,
    required int waterSourceCode,
    required int sanitationFacilityCode,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : householdUuid = Value(householdUuid),
        sitioName = Value(sitioName),
        dwellingType = Value(dwellingType),
        waterSourceCode = Value(waterSourceCode),
        sanitationFacilityCode = Value(sanitationFacilityCode),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Household> custom({
    Expression<String>? householdUuid,
    Expression<String>? sitioName,
    Expression<String>? dwellingType,
    Expression<int>? waterSourceCode,
    Expression<int>? sanitationFacilityCode,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (householdUuid != null) 'household_uuid': householdUuid,
      if (sitioName != null) 'sitio_name': sitioName,
      if (dwellingType != null) 'dwelling_type': dwellingType,
      if (waterSourceCode != null) 'water_source_code': waterSourceCode,
      if (sanitationFacilityCode != null)
        'sanitation_facility_code': sanitationFacilityCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdsCompanion copyWith(
      {Value<String>? householdUuid,
      Value<String>? sitioName,
      Value<String>? dwellingType,
      Value<int>? waterSourceCode,
      Value<int>? sanitationFacilityCode,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return HouseholdsCompanion(
      householdUuid: householdUuid ?? this.householdUuid,
      sitioName: sitioName ?? this.sitioName,
      dwellingType: dwellingType ?? this.dwellingType,
      waterSourceCode: waterSourceCode ?? this.waterSourceCode,
      sanitationFacilityCode:
          sanitationFacilityCode ?? this.sanitationFacilityCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (householdUuid.present) {
      map['household_uuid'] = Variable<String>(householdUuid.value);
    }
    if (sitioName.present) {
      map['sitio_name'] = Variable<String>(sitioName.value);
    }
    if (dwellingType.present) {
      map['dwelling_type'] = Variable<String>(dwellingType.value);
    }
    if (waterSourceCode.present) {
      map['water_source_code'] = Variable<int>(waterSourceCode.value);
    }
    if (sanitationFacilityCode.present) {
      map['sanitation_facility_code'] =
          Variable<int>(sanitationFacilityCode.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdsCompanion(')
          ..write('householdUuid: $householdUuid, ')
          ..write('sitioName: $sitioName, ')
          ..write('dwellingType: $dwellingType, ')
          ..write('waterSourceCode: $waterSourceCode, ')
          ..write('sanitationFacilityCode: $sanitationFacilityCode, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _patientUuidMeta =
      const VerificationMeta('patientUuid');
  @override
  late final GeneratedColumn<String> patientUuid = GeneratedColumn<String>(
      'patient_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _householdUuidMeta =
      const VerificationMeta('householdUuid');
  @override
  late final GeneratedColumn<String> householdUuid = GeneratedColumn<String>(
      'household_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES households (household_uuid)'));
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _birthdateMeta =
      const VerificationMeta('birthdate');
  @override
  late final GeneratedColumn<String> birthdate = GeneratedColumn<String>(
      'birthdate', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
      'sex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _philhealthIdMeta =
      const VerificationMeta('philhealthId');
  @override
  late final GeneratedColumn<String> philhealthId = GeneratedColumn<String>(
      'philhealth_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        patientUuid,
        householdUuid,
        firstName,
        lastName,
        birthdate,
        sex,
        philhealthId,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(Insertable<Patient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('patient_uuid')) {
      context.handle(
          _patientUuidMeta,
          patientUuid.isAcceptableOrUnknown(
              data['patient_uuid']!, _patientUuidMeta));
    } else if (isInserting) {
      context.missing(_patientUuidMeta);
    }
    if (data.containsKey('household_uuid')) {
      context.handle(
          _householdUuidMeta,
          householdUuid.isAcceptableOrUnknown(
              data['household_uuid']!, _householdUuidMeta));
    } else if (isInserting) {
      context.missing(_householdUuidMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('birthdate')) {
      context.handle(_birthdateMeta,
          birthdate.isAcceptableOrUnknown(data['birthdate']!, _birthdateMeta));
    } else if (isInserting) {
      context.missing(_birthdateMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
          _sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('philhealth_id')) {
      context.handle(
          _philhealthIdMeta,
          philhealthId.isAcceptableOrUnknown(
              data['philhealth_id']!, _philhealthIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {patientUuid};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      patientUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_uuid'])!,
      householdUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}household_uuid'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      birthdate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}birthdate'])!,
      sex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex'])!,
      philhealthId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}philhealth_id']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final String patientUuid;
  final String householdUuid;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String sex;
  final String? philhealthId;
  final int isActive;
  final String createdAt;
  final String updatedAt;
  const Patient(
      {required this.patientUuid,
      required this.householdUuid,
      required this.firstName,
      required this.lastName,
      required this.birthdate,
      required this.sex,
      this.philhealthId,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['patient_uuid'] = Variable<String>(patientUuid);
    map['household_uuid'] = Variable<String>(householdUuid);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['birthdate'] = Variable<String>(birthdate);
    map['sex'] = Variable<String>(sex);
    if (!nullToAbsent || philhealthId != null) {
      map['philhealth_id'] = Variable<String>(philhealthId);
    }
    map['is_active'] = Variable<int>(isActive);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      patientUuid: Value(patientUuid),
      householdUuid: Value(householdUuid),
      firstName: Value(firstName),
      lastName: Value(lastName),
      birthdate: Value(birthdate),
      sex: Value(sex),
      philhealthId: philhealthId == null && nullToAbsent
          ? const Value.absent()
          : Value(philhealthId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Patient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      patientUuid: serializer.fromJson<String>(json['patientUuid']),
      householdUuid: serializer.fromJson<String>(json['householdUuid']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      birthdate: serializer.fromJson<String>(json['birthdate']),
      sex: serializer.fromJson<String>(json['sex']),
      philhealthId: serializer.fromJson<String?>(json['philhealthId']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'patientUuid': serializer.toJson<String>(patientUuid),
      'householdUuid': serializer.toJson<String>(householdUuid),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'birthdate': serializer.toJson<String>(birthdate),
      'sex': serializer.toJson<String>(sex),
      'philhealthId': serializer.toJson<String?>(philhealthId),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Patient copyWith(
          {String? patientUuid,
          String? householdUuid,
          String? firstName,
          String? lastName,
          String? birthdate,
          String? sex,
          Value<String?> philhealthId = const Value.absent(),
          int? isActive,
          String? createdAt,
          String? updatedAt}) =>
      Patient(
        patientUuid: patientUuid ?? this.patientUuid,
        householdUuid: householdUuid ?? this.householdUuid,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        birthdate: birthdate ?? this.birthdate,
        sex: sex ?? this.sex,
        philhealthId:
            philhealthId.present ? philhealthId.value : this.philhealthId,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      patientUuid:
          data.patientUuid.present ? data.patientUuid.value : this.patientUuid,
      householdUuid: data.householdUuid.present
          ? data.householdUuid.value
          : this.householdUuid,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      birthdate: data.birthdate.present ? data.birthdate.value : this.birthdate,
      sex: data.sex.present ? data.sex.value : this.sex,
      philhealthId: data.philhealthId.present
          ? data.philhealthId.value
          : this.philhealthId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('patientUuid: $patientUuid, ')
          ..write('householdUuid: $householdUuid, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('birthdate: $birthdate, ')
          ..write('sex: $sex, ')
          ..write('philhealthId: $philhealthId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(patientUuid, householdUuid, firstName,
      lastName, birthdate, sex, philhealthId, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.patientUuid == this.patientUuid &&
          other.householdUuid == this.householdUuid &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.birthdate == this.birthdate &&
          other.sex == this.sex &&
          other.philhealthId == this.philhealthId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<String> patientUuid;
  final Value<String> householdUuid;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> birthdate;
  final Value<String> sex;
  final Value<String?> philhealthId;
  final Value<int> isActive;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const PatientsCompanion({
    this.patientUuid = const Value.absent(),
    this.householdUuid = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.birthdate = const Value.absent(),
    this.sex = const Value.absent(),
    this.philhealthId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    required String patientUuid,
    required String householdUuid,
    required String firstName,
    required String lastName,
    required String birthdate,
    required String sex,
    this.philhealthId = const Value.absent(),
    this.isActive = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : patientUuid = Value(patientUuid),
        householdUuid = Value(householdUuid),
        firstName = Value(firstName),
        lastName = Value(lastName),
        birthdate = Value(birthdate),
        sex = Value(sex),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Patient> custom({
    Expression<String>? patientUuid,
    Expression<String>? householdUuid,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? birthdate,
    Expression<String>? sex,
    Expression<String>? philhealthId,
    Expression<int>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (patientUuid != null) 'patient_uuid': patientUuid,
      if (householdUuid != null) 'household_uuid': householdUuid,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (birthdate != null) 'birthdate': birthdate,
      if (sex != null) 'sex': sex,
      if (philhealthId != null) 'philhealth_id': philhealthId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith(
      {Value<String>? patientUuid,
      Value<String>? householdUuid,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String>? birthdate,
      Value<String>? sex,
      Value<String?>? philhealthId,
      Value<int>? isActive,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return PatientsCompanion(
      patientUuid: patientUuid ?? this.patientUuid,
      householdUuid: householdUuid ?? this.householdUuid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      sex: sex ?? this.sex,
      philhealthId: philhealthId ?? this.philhealthId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (patientUuid.present) {
      map['patient_uuid'] = Variable<String>(patientUuid.value);
    }
    if (householdUuid.present) {
      map['household_uuid'] = Variable<String>(householdUuid.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (birthdate.present) {
      map['birthdate'] = Variable<String>(birthdate.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (philhealthId.present) {
      map['philhealth_id'] = Variable<String>(philhealthId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('patientUuid: $patientUuid, ')
          ..write('householdUuid: $householdUuid, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('birthdate: $birthdate, ')
          ..write('sex: $sex, ')
          ..write('philhealthId: $philhealthId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EncountersTable extends Encounters
    with TableInfo<$EncountersTable, Encounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EncountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _encounterUuidMeta =
      const VerificationMeta('encounterUuid');
  @override
  late final GeneratedColumn<String> encounterUuid = GeneratedColumn<String>(
      'encounter_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientUuidMeta =
      const VerificationMeta('patientUuid');
  @override
  late final GeneratedColumn<String> patientUuid = GeneratedColumn<String>(
      'patient_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES patients (patient_uuid)'));
  static const VerificationMeta _bhwUserIdMeta =
      const VerificationMeta('bhwUserId');
  @override
  late final GeneratedColumn<String> bhwUserId = GeneratedColumn<String>(
      'bhw_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _encounterTypeMeta =
      const VerificationMeta('encounterType');
  @override
  late final GeneratedColumn<String> encounterType = GeneratedColumn<String>(
      'encounter_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _encounterTimestampMeta =
      const VerificationMeta('encounterTimestamp');
  @override
  late final GeneratedColumn<String> encounterTimestamp =
      GeneratedColumn<String>('encounter_timestamp', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triageRiskLevelMeta =
      const VerificationMeta('triageRiskLevel');
  @override
  late final GeneratedColumn<String> triageRiskLevel = GeneratedColumn<String>(
      'triage_risk_level', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clinicalNotesMeta =
      const VerificationMeta('clinicalNotes');
  @override
  late final GeneratedColumn<String> clinicalNotes = GeneratedColumn<String>(
      'clinical_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        encounterUuid,
        patientUuid,
        bhwUserId,
        encounterType,
        encounterTimestamp,
        triageRiskLevel,
        clinicalNotes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'encounters';
  @override
  VerificationContext validateIntegrity(Insertable<Encounter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('encounter_uuid')) {
      context.handle(
          _encounterUuidMeta,
          encounterUuid.isAcceptableOrUnknown(
              data['encounter_uuid']!, _encounterUuidMeta));
    } else if (isInserting) {
      context.missing(_encounterUuidMeta);
    }
    if (data.containsKey('patient_uuid')) {
      context.handle(
          _patientUuidMeta,
          patientUuid.isAcceptableOrUnknown(
              data['patient_uuid']!, _patientUuidMeta));
    } else if (isInserting) {
      context.missing(_patientUuidMeta);
    }
    if (data.containsKey('bhw_user_id')) {
      context.handle(
          _bhwUserIdMeta,
          bhwUserId.isAcceptableOrUnknown(
              data['bhw_user_id']!, _bhwUserIdMeta));
    } else if (isInserting) {
      context.missing(_bhwUserIdMeta);
    }
    if (data.containsKey('encounter_type')) {
      context.handle(
          _encounterTypeMeta,
          encounterType.isAcceptableOrUnknown(
              data['encounter_type']!, _encounterTypeMeta));
    } else if (isInserting) {
      context.missing(_encounterTypeMeta);
    }
    if (data.containsKey('encounter_timestamp')) {
      context.handle(
          _encounterTimestampMeta,
          encounterTimestamp.isAcceptableOrUnknown(
              data['encounter_timestamp']!, _encounterTimestampMeta));
    } else if (isInserting) {
      context.missing(_encounterTimestampMeta);
    }
    if (data.containsKey('triage_risk_level')) {
      context.handle(
          _triageRiskLevelMeta,
          triageRiskLevel.isAcceptableOrUnknown(
              data['triage_risk_level']!, _triageRiskLevelMeta));
    } else if (isInserting) {
      context.missing(_triageRiskLevelMeta);
    }
    if (data.containsKey('clinical_notes')) {
      context.handle(
          _clinicalNotesMeta,
          clinicalNotes.isAcceptableOrUnknown(
              data['clinical_notes']!, _clinicalNotesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {encounterUuid};
  @override
  Encounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Encounter(
      encounterUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encounter_uuid'])!,
      patientUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_uuid'])!,
      bhwUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bhw_user_id'])!,
      encounterType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encounter_type'])!,
      encounterTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}encounter_timestamp'])!,
      triageRiskLevel: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}triage_risk_level'])!,
      clinicalNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}clinical_notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $EncountersTable createAlias(String alias) {
    return $EncountersTable(attachedDatabase, alias);
  }
}

class Encounter extends DataClass implements Insertable<Encounter> {
  final String encounterUuid;
  final String patientUuid;
  final String bhwUserId;
  final String encounterType;
  final String encounterTimestamp;
  final String triageRiskLevel;
  final String? clinicalNotes;
  final String createdAt;
  const Encounter(
      {required this.encounterUuid,
      required this.patientUuid,
      required this.bhwUserId,
      required this.encounterType,
      required this.encounterTimestamp,
      required this.triageRiskLevel,
      this.clinicalNotes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['encounter_uuid'] = Variable<String>(encounterUuid);
    map['patient_uuid'] = Variable<String>(patientUuid);
    map['bhw_user_id'] = Variable<String>(bhwUserId);
    map['encounter_type'] = Variable<String>(encounterType);
    map['encounter_timestamp'] = Variable<String>(encounterTimestamp);
    map['triage_risk_level'] = Variable<String>(triageRiskLevel);
    if (!nullToAbsent || clinicalNotes != null) {
      map['clinical_notes'] = Variable<String>(clinicalNotes);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  EncountersCompanion toCompanion(bool nullToAbsent) {
    return EncountersCompanion(
      encounterUuid: Value(encounterUuid),
      patientUuid: Value(patientUuid),
      bhwUserId: Value(bhwUserId),
      encounterType: Value(encounterType),
      encounterTimestamp: Value(encounterTimestamp),
      triageRiskLevel: Value(triageRiskLevel),
      clinicalNotes: clinicalNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(clinicalNotes),
      createdAt: Value(createdAt),
    );
  }

  factory Encounter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Encounter(
      encounterUuid: serializer.fromJson<String>(json['encounterUuid']),
      patientUuid: serializer.fromJson<String>(json['patientUuid']),
      bhwUserId: serializer.fromJson<String>(json['bhwUserId']),
      encounterType: serializer.fromJson<String>(json['encounterType']),
      encounterTimestamp:
          serializer.fromJson<String>(json['encounterTimestamp']),
      triageRiskLevel: serializer.fromJson<String>(json['triageRiskLevel']),
      clinicalNotes: serializer.fromJson<String?>(json['clinicalNotes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'encounterUuid': serializer.toJson<String>(encounterUuid),
      'patientUuid': serializer.toJson<String>(patientUuid),
      'bhwUserId': serializer.toJson<String>(bhwUserId),
      'encounterType': serializer.toJson<String>(encounterType),
      'encounterTimestamp': serializer.toJson<String>(encounterTimestamp),
      'triageRiskLevel': serializer.toJson<String>(triageRiskLevel),
      'clinicalNotes': serializer.toJson<String?>(clinicalNotes),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  Encounter copyWith(
          {String? encounterUuid,
          String? patientUuid,
          String? bhwUserId,
          String? encounterType,
          String? encounterTimestamp,
          String? triageRiskLevel,
          Value<String?> clinicalNotes = const Value.absent(),
          String? createdAt}) =>
      Encounter(
        encounterUuid: encounterUuid ?? this.encounterUuid,
        patientUuid: patientUuid ?? this.patientUuid,
        bhwUserId: bhwUserId ?? this.bhwUserId,
        encounterType: encounterType ?? this.encounterType,
        encounterTimestamp: encounterTimestamp ?? this.encounterTimestamp,
        triageRiskLevel: triageRiskLevel ?? this.triageRiskLevel,
        clinicalNotes:
            clinicalNotes.present ? clinicalNotes.value : this.clinicalNotes,
        createdAt: createdAt ?? this.createdAt,
      );
  Encounter copyWithCompanion(EncountersCompanion data) {
    return Encounter(
      encounterUuid: data.encounterUuid.present
          ? data.encounterUuid.value
          : this.encounterUuid,
      patientUuid:
          data.patientUuid.present ? data.patientUuid.value : this.patientUuid,
      bhwUserId: data.bhwUserId.present ? data.bhwUserId.value : this.bhwUserId,
      encounterType: data.encounterType.present
          ? data.encounterType.value
          : this.encounterType,
      encounterTimestamp: data.encounterTimestamp.present
          ? data.encounterTimestamp.value
          : this.encounterTimestamp,
      triageRiskLevel: data.triageRiskLevel.present
          ? data.triageRiskLevel.value
          : this.triageRiskLevel,
      clinicalNotes: data.clinicalNotes.present
          ? data.clinicalNotes.value
          : this.clinicalNotes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Encounter(')
          ..write('encounterUuid: $encounterUuid, ')
          ..write('patientUuid: $patientUuid, ')
          ..write('bhwUserId: $bhwUserId, ')
          ..write('encounterType: $encounterType, ')
          ..write('encounterTimestamp: $encounterTimestamp, ')
          ..write('triageRiskLevel: $triageRiskLevel, ')
          ..write('clinicalNotes: $clinicalNotes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      encounterUuid,
      patientUuid,
      bhwUserId,
      encounterType,
      encounterTimestamp,
      triageRiskLevel,
      clinicalNotes,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Encounter &&
          other.encounterUuid == this.encounterUuid &&
          other.patientUuid == this.patientUuid &&
          other.bhwUserId == this.bhwUserId &&
          other.encounterType == this.encounterType &&
          other.encounterTimestamp == this.encounterTimestamp &&
          other.triageRiskLevel == this.triageRiskLevel &&
          other.clinicalNotes == this.clinicalNotes &&
          other.createdAt == this.createdAt);
}

class EncountersCompanion extends UpdateCompanion<Encounter> {
  final Value<String> encounterUuid;
  final Value<String> patientUuid;
  final Value<String> bhwUserId;
  final Value<String> encounterType;
  final Value<String> encounterTimestamp;
  final Value<String> triageRiskLevel;
  final Value<String?> clinicalNotes;
  final Value<String> createdAt;
  final Value<int> rowid;
  const EncountersCompanion({
    this.encounterUuid = const Value.absent(),
    this.patientUuid = const Value.absent(),
    this.bhwUserId = const Value.absent(),
    this.encounterType = const Value.absent(),
    this.encounterTimestamp = const Value.absent(),
    this.triageRiskLevel = const Value.absent(),
    this.clinicalNotes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EncountersCompanion.insert({
    required String encounterUuid,
    required String patientUuid,
    required String bhwUserId,
    required String encounterType,
    required String encounterTimestamp,
    required String triageRiskLevel,
    this.clinicalNotes = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  })  : encounterUuid = Value(encounterUuid),
        patientUuid = Value(patientUuid),
        bhwUserId = Value(bhwUserId),
        encounterType = Value(encounterType),
        encounterTimestamp = Value(encounterTimestamp),
        triageRiskLevel = Value(triageRiskLevel),
        createdAt = Value(createdAt);
  static Insertable<Encounter> custom({
    Expression<String>? encounterUuid,
    Expression<String>? patientUuid,
    Expression<String>? bhwUserId,
    Expression<String>? encounterType,
    Expression<String>? encounterTimestamp,
    Expression<String>? triageRiskLevel,
    Expression<String>? clinicalNotes,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (encounterUuid != null) 'encounter_uuid': encounterUuid,
      if (patientUuid != null) 'patient_uuid': patientUuid,
      if (bhwUserId != null) 'bhw_user_id': bhwUserId,
      if (encounterType != null) 'encounter_type': encounterType,
      if (encounterTimestamp != null) 'encounter_timestamp': encounterTimestamp,
      if (triageRiskLevel != null) 'triage_risk_level': triageRiskLevel,
      if (clinicalNotes != null) 'clinical_notes': clinicalNotes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EncountersCompanion copyWith(
      {Value<String>? encounterUuid,
      Value<String>? patientUuid,
      Value<String>? bhwUserId,
      Value<String>? encounterType,
      Value<String>? encounterTimestamp,
      Value<String>? triageRiskLevel,
      Value<String?>? clinicalNotes,
      Value<String>? createdAt,
      Value<int>? rowid}) {
    return EncountersCompanion(
      encounterUuid: encounterUuid ?? this.encounterUuid,
      patientUuid: patientUuid ?? this.patientUuid,
      bhwUserId: bhwUserId ?? this.bhwUserId,
      encounterType: encounterType ?? this.encounterType,
      encounterTimestamp: encounterTimestamp ?? this.encounterTimestamp,
      triageRiskLevel: triageRiskLevel ?? this.triageRiskLevel,
      clinicalNotes: clinicalNotes ?? this.clinicalNotes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (encounterUuid.present) {
      map['encounter_uuid'] = Variable<String>(encounterUuid.value);
    }
    if (patientUuid.present) {
      map['patient_uuid'] = Variable<String>(patientUuid.value);
    }
    if (bhwUserId.present) {
      map['bhw_user_id'] = Variable<String>(bhwUserId.value);
    }
    if (encounterType.present) {
      map['encounter_type'] = Variable<String>(encounterType.value);
    }
    if (encounterTimestamp.present) {
      map['encounter_timestamp'] = Variable<String>(encounterTimestamp.value);
    }
    if (triageRiskLevel.present) {
      map['triage_risk_level'] = Variable<String>(triageRiskLevel.value);
    }
    if (clinicalNotes.present) {
      map['clinical_notes'] = Variable<String>(clinicalNotes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EncountersCompanion(')
          ..write('encounterUuid: $encounterUuid, ')
          ..write('patientUuid: $patientUuid, ')
          ..write('bhwUserId: $bhwUserId, ')
          ..write('encounterType: $encounterType, ')
          ..write('encounterTimestamp: $encounterTimestamp, ')
          ..write('triageRiskLevel: $triageRiskLevel, ')
          ..write('clinicalNotes: $clinicalNotes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaternalCareDetailsTable extends MaternalCareDetails
    with TableInfo<$MaternalCareDetailsTable, MaternalCareDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaternalCareDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _encounterUuidMeta =
      const VerificationMeta('encounterUuid');
  @override
  late final GeneratedColumn<String> encounterUuid = GeneratedColumn<String>(
      'encounter_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES encounters (encounter_uuid)'));
  static const VerificationMeta _lmpDateMeta =
      const VerificationMeta('lmpDate');
  @override
  late final GeneratedColumn<String> lmpDate = GeneratedColumn<String>(
      'lmp_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _edcDateMeta =
      const VerificationMeta('edcDate');
  @override
  late final GeneratedColumn<String> edcDate = GeneratedColumn<String>(
      'edc_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gravidityMeta =
      const VerificationMeta('gravidity');
  @override
  late final GeneratedColumn<int> gravidity = GeneratedColumn<int>(
      'gravidity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _parityMeta = const VerificationMeta('parity');
  @override
  late final GeneratedColumn<int> parity = GeneratedColumn<int>(
      'parity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _systolicBpMeta =
      const VerificationMeta('systolicBp');
  @override
  late final GeneratedColumn<int> systolicBp = GeneratedColumn<int>(
      'systolic_bp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _diastolicBpMeta =
      const VerificationMeta('diastolicBp');
  @override
  late final GeneratedColumn<int> diastolicBp = GeneratedColumn<int>(
      'diastolic_bp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _maternalWeightKgMeta =
      const VerificationMeta('maternalWeightKg');
  @override
  late final GeneratedColumn<double> maternalWeightKg = GeneratedColumn<double>(
      'maternal_weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fundicHeightCmMeta =
      const VerificationMeta('fundicHeightCm');
  @override
  late final GeneratedColumn<double> fundicHeightCm = GeneratedColumn<double>(
      'fundic_height_cm', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _ironFolicGivenMeta =
      const VerificationMeta('ironFolicGiven');
  @override
  late final GeneratedColumn<int> ironFolicGiven = GeneratedColumn<int>(
      'iron_folic_given', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        encounterUuid,
        lmpDate,
        edcDate,
        gravidity,
        parity,
        systolicBp,
        diastolicBp,
        maternalWeightKg,
        fundicHeightCm,
        ironFolicGiven
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'maternal_care_details';
  @override
  VerificationContext validateIntegrity(Insertable<MaternalCareDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('encounter_uuid')) {
      context.handle(
          _encounterUuidMeta,
          encounterUuid.isAcceptableOrUnknown(
              data['encounter_uuid']!, _encounterUuidMeta));
    } else if (isInserting) {
      context.missing(_encounterUuidMeta);
    }
    if (data.containsKey('lmp_date')) {
      context.handle(_lmpDateMeta,
          lmpDate.isAcceptableOrUnknown(data['lmp_date']!, _lmpDateMeta));
    } else if (isInserting) {
      context.missing(_lmpDateMeta);
    }
    if (data.containsKey('edc_date')) {
      context.handle(_edcDateMeta,
          edcDate.isAcceptableOrUnknown(data['edc_date']!, _edcDateMeta));
    } else if (isInserting) {
      context.missing(_edcDateMeta);
    }
    if (data.containsKey('gravidity')) {
      context.handle(_gravidityMeta,
          gravidity.isAcceptableOrUnknown(data['gravidity']!, _gravidityMeta));
    } else if (isInserting) {
      context.missing(_gravidityMeta);
    }
    if (data.containsKey('parity')) {
      context.handle(_parityMeta,
          parity.isAcceptableOrUnknown(data['parity']!, _parityMeta));
    } else if (isInserting) {
      context.missing(_parityMeta);
    }
    if (data.containsKey('systolic_bp')) {
      context.handle(
          _systolicBpMeta,
          systolicBp.isAcceptableOrUnknown(
              data['systolic_bp']!, _systolicBpMeta));
    } else if (isInserting) {
      context.missing(_systolicBpMeta);
    }
    if (data.containsKey('diastolic_bp')) {
      context.handle(
          _diastolicBpMeta,
          diastolicBp.isAcceptableOrUnknown(
              data['diastolic_bp']!, _diastolicBpMeta));
    } else if (isInserting) {
      context.missing(_diastolicBpMeta);
    }
    if (data.containsKey('maternal_weight_kg')) {
      context.handle(
          _maternalWeightKgMeta,
          maternalWeightKg.isAcceptableOrUnknown(
              data['maternal_weight_kg']!, _maternalWeightKgMeta));
    } else if (isInserting) {
      context.missing(_maternalWeightKgMeta);
    }
    if (data.containsKey('fundic_height_cm')) {
      context.handle(
          _fundicHeightCmMeta,
          fundicHeightCm.isAcceptableOrUnknown(
              data['fundic_height_cm']!, _fundicHeightCmMeta));
    }
    if (data.containsKey('iron_folic_given')) {
      context.handle(
          _ironFolicGivenMeta,
          ironFolicGiven.isAcceptableOrUnknown(
              data['iron_folic_given']!, _ironFolicGivenMeta));
    } else if (isInserting) {
      context.missing(_ironFolicGivenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {encounterUuid};
  @override
  MaternalCareDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaternalCareDetail(
      encounterUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encounter_uuid'])!,
      lmpDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lmp_date'])!,
      edcDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}edc_date'])!,
      gravidity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gravidity'])!,
      parity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parity'])!,
      systolicBp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}systolic_bp'])!,
      diastolicBp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}diastolic_bp'])!,
      maternalWeightKg: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}maternal_weight_kg'])!,
      fundicHeightCm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}fundic_height_cm']),
      ironFolicGiven: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}iron_folic_given'])!,
    );
  }

  @override
  $MaternalCareDetailsTable createAlias(String alias) {
    return $MaternalCareDetailsTable(attachedDatabase, alias);
  }
}

class MaternalCareDetail extends DataClass
    implements Insertable<MaternalCareDetail> {
  final String encounterUuid;
  final String lmpDate;
  final String edcDate;
  final int gravidity;
  final int parity;
  final int systolicBp;
  final int diastolicBp;
  final double maternalWeightKg;
  final double? fundicHeightCm;
  final int ironFolicGiven;
  const MaternalCareDetail(
      {required this.encounterUuid,
      required this.lmpDate,
      required this.edcDate,
      required this.gravidity,
      required this.parity,
      required this.systolicBp,
      required this.diastolicBp,
      required this.maternalWeightKg,
      this.fundicHeightCm,
      required this.ironFolicGiven});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['encounter_uuid'] = Variable<String>(encounterUuid);
    map['lmp_date'] = Variable<String>(lmpDate);
    map['edc_date'] = Variable<String>(edcDate);
    map['gravidity'] = Variable<int>(gravidity);
    map['parity'] = Variable<int>(parity);
    map['systolic_bp'] = Variable<int>(systolicBp);
    map['diastolic_bp'] = Variable<int>(diastolicBp);
    map['maternal_weight_kg'] = Variable<double>(maternalWeightKg);
    if (!nullToAbsent || fundicHeightCm != null) {
      map['fundic_height_cm'] = Variable<double>(fundicHeightCm);
    }
    map['iron_folic_given'] = Variable<int>(ironFolicGiven);
    return map;
  }

  MaternalCareDetailsCompanion toCompanion(bool nullToAbsent) {
    return MaternalCareDetailsCompanion(
      encounterUuid: Value(encounterUuid),
      lmpDate: Value(lmpDate),
      edcDate: Value(edcDate),
      gravidity: Value(gravidity),
      parity: Value(parity),
      systolicBp: Value(systolicBp),
      diastolicBp: Value(diastolicBp),
      maternalWeightKg: Value(maternalWeightKg),
      fundicHeightCm: fundicHeightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(fundicHeightCm),
      ironFolicGiven: Value(ironFolicGiven),
    );
  }

  factory MaternalCareDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaternalCareDetail(
      encounterUuid: serializer.fromJson<String>(json['encounterUuid']),
      lmpDate: serializer.fromJson<String>(json['lmpDate']),
      edcDate: serializer.fromJson<String>(json['edcDate']),
      gravidity: serializer.fromJson<int>(json['gravidity']),
      parity: serializer.fromJson<int>(json['parity']),
      systolicBp: serializer.fromJson<int>(json['systolicBp']),
      diastolicBp: serializer.fromJson<int>(json['diastolicBp']),
      maternalWeightKg: serializer.fromJson<double>(json['maternalWeightKg']),
      fundicHeightCm: serializer.fromJson<double?>(json['fundicHeightCm']),
      ironFolicGiven: serializer.fromJson<int>(json['ironFolicGiven']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'encounterUuid': serializer.toJson<String>(encounterUuid),
      'lmpDate': serializer.toJson<String>(lmpDate),
      'edcDate': serializer.toJson<String>(edcDate),
      'gravidity': serializer.toJson<int>(gravidity),
      'parity': serializer.toJson<int>(parity),
      'systolicBp': serializer.toJson<int>(systolicBp),
      'diastolicBp': serializer.toJson<int>(diastolicBp),
      'maternalWeightKg': serializer.toJson<double>(maternalWeightKg),
      'fundicHeightCm': serializer.toJson<double?>(fundicHeightCm),
      'ironFolicGiven': serializer.toJson<int>(ironFolicGiven),
    };
  }

  MaternalCareDetail copyWith(
          {String? encounterUuid,
          String? lmpDate,
          String? edcDate,
          int? gravidity,
          int? parity,
          int? systolicBp,
          int? diastolicBp,
          double? maternalWeightKg,
          Value<double?> fundicHeightCm = const Value.absent(),
          int? ironFolicGiven}) =>
      MaternalCareDetail(
        encounterUuid: encounterUuid ?? this.encounterUuid,
        lmpDate: lmpDate ?? this.lmpDate,
        edcDate: edcDate ?? this.edcDate,
        gravidity: gravidity ?? this.gravidity,
        parity: parity ?? this.parity,
        systolicBp: systolicBp ?? this.systolicBp,
        diastolicBp: diastolicBp ?? this.diastolicBp,
        maternalWeightKg: maternalWeightKg ?? this.maternalWeightKg,
        fundicHeightCm:
            fundicHeightCm.present ? fundicHeightCm.value : this.fundicHeightCm,
        ironFolicGiven: ironFolicGiven ?? this.ironFolicGiven,
      );
  MaternalCareDetail copyWithCompanion(MaternalCareDetailsCompanion data) {
    return MaternalCareDetail(
      encounterUuid: data.encounterUuid.present
          ? data.encounterUuid.value
          : this.encounterUuid,
      lmpDate: data.lmpDate.present ? data.lmpDate.value : this.lmpDate,
      edcDate: data.edcDate.present ? data.edcDate.value : this.edcDate,
      gravidity: data.gravidity.present ? data.gravidity.value : this.gravidity,
      parity: data.parity.present ? data.parity.value : this.parity,
      systolicBp:
          data.systolicBp.present ? data.systolicBp.value : this.systolicBp,
      diastolicBp:
          data.diastolicBp.present ? data.diastolicBp.value : this.diastolicBp,
      maternalWeightKg: data.maternalWeightKg.present
          ? data.maternalWeightKg.value
          : this.maternalWeightKg,
      fundicHeightCm: data.fundicHeightCm.present
          ? data.fundicHeightCm.value
          : this.fundicHeightCm,
      ironFolicGiven: data.ironFolicGiven.present
          ? data.ironFolicGiven.value
          : this.ironFolicGiven,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaternalCareDetail(')
          ..write('encounterUuid: $encounterUuid, ')
          ..write('lmpDate: $lmpDate, ')
          ..write('edcDate: $edcDate, ')
          ..write('gravidity: $gravidity, ')
          ..write('parity: $parity, ')
          ..write('systolicBp: $systolicBp, ')
          ..write('diastolicBp: $diastolicBp, ')
          ..write('maternalWeightKg: $maternalWeightKg, ')
          ..write('fundicHeightCm: $fundicHeightCm, ')
          ..write('ironFolicGiven: $ironFolicGiven')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      encounterUuid,
      lmpDate,
      edcDate,
      gravidity,
      parity,
      systolicBp,
      diastolicBp,
      maternalWeightKg,
      fundicHeightCm,
      ironFolicGiven);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaternalCareDetail &&
          other.encounterUuid == this.encounterUuid &&
          other.lmpDate == this.lmpDate &&
          other.edcDate == this.edcDate &&
          other.gravidity == this.gravidity &&
          other.parity == this.parity &&
          other.systolicBp == this.systolicBp &&
          other.diastolicBp == this.diastolicBp &&
          other.maternalWeightKg == this.maternalWeightKg &&
          other.fundicHeightCm == this.fundicHeightCm &&
          other.ironFolicGiven == this.ironFolicGiven);
}

class MaternalCareDetailsCompanion extends UpdateCompanion<MaternalCareDetail> {
  final Value<String> encounterUuid;
  final Value<String> lmpDate;
  final Value<String> edcDate;
  final Value<int> gravidity;
  final Value<int> parity;
  final Value<int> systolicBp;
  final Value<int> diastolicBp;
  final Value<double> maternalWeightKg;
  final Value<double?> fundicHeightCm;
  final Value<int> ironFolicGiven;
  final Value<int> rowid;
  const MaternalCareDetailsCompanion({
    this.encounterUuid = const Value.absent(),
    this.lmpDate = const Value.absent(),
    this.edcDate = const Value.absent(),
    this.gravidity = const Value.absent(),
    this.parity = const Value.absent(),
    this.systolicBp = const Value.absent(),
    this.diastolicBp = const Value.absent(),
    this.maternalWeightKg = const Value.absent(),
    this.fundicHeightCm = const Value.absent(),
    this.ironFolicGiven = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaternalCareDetailsCompanion.insert({
    required String encounterUuid,
    required String lmpDate,
    required String edcDate,
    required int gravidity,
    required int parity,
    required int systolicBp,
    required int diastolicBp,
    required double maternalWeightKg,
    this.fundicHeightCm = const Value.absent(),
    required int ironFolicGiven,
    this.rowid = const Value.absent(),
  })  : encounterUuid = Value(encounterUuid),
        lmpDate = Value(lmpDate),
        edcDate = Value(edcDate),
        gravidity = Value(gravidity),
        parity = Value(parity),
        systolicBp = Value(systolicBp),
        diastolicBp = Value(diastolicBp),
        maternalWeightKg = Value(maternalWeightKg),
        ironFolicGiven = Value(ironFolicGiven);
  static Insertable<MaternalCareDetail> custom({
    Expression<String>? encounterUuid,
    Expression<String>? lmpDate,
    Expression<String>? edcDate,
    Expression<int>? gravidity,
    Expression<int>? parity,
    Expression<int>? systolicBp,
    Expression<int>? diastolicBp,
    Expression<double>? maternalWeightKg,
    Expression<double>? fundicHeightCm,
    Expression<int>? ironFolicGiven,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (encounterUuid != null) 'encounter_uuid': encounterUuid,
      if (lmpDate != null) 'lmp_date': lmpDate,
      if (edcDate != null) 'edc_date': edcDate,
      if (gravidity != null) 'gravidity': gravidity,
      if (parity != null) 'parity': parity,
      if (systolicBp != null) 'systolic_bp': systolicBp,
      if (diastolicBp != null) 'diastolic_bp': diastolicBp,
      if (maternalWeightKg != null) 'maternal_weight_kg': maternalWeightKg,
      if (fundicHeightCm != null) 'fundic_height_cm': fundicHeightCm,
      if (ironFolicGiven != null) 'iron_folic_given': ironFolicGiven,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaternalCareDetailsCompanion copyWith(
      {Value<String>? encounterUuid,
      Value<String>? lmpDate,
      Value<String>? edcDate,
      Value<int>? gravidity,
      Value<int>? parity,
      Value<int>? systolicBp,
      Value<int>? diastolicBp,
      Value<double>? maternalWeightKg,
      Value<double?>? fundicHeightCm,
      Value<int>? ironFolicGiven,
      Value<int>? rowid}) {
    return MaternalCareDetailsCompanion(
      encounterUuid: encounterUuid ?? this.encounterUuid,
      lmpDate: lmpDate ?? this.lmpDate,
      edcDate: edcDate ?? this.edcDate,
      gravidity: gravidity ?? this.gravidity,
      parity: parity ?? this.parity,
      systolicBp: systolicBp ?? this.systolicBp,
      diastolicBp: diastolicBp ?? this.diastolicBp,
      maternalWeightKg: maternalWeightKg ?? this.maternalWeightKg,
      fundicHeightCm: fundicHeightCm ?? this.fundicHeightCm,
      ironFolicGiven: ironFolicGiven ?? this.ironFolicGiven,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (encounterUuid.present) {
      map['encounter_uuid'] = Variable<String>(encounterUuid.value);
    }
    if (lmpDate.present) {
      map['lmp_date'] = Variable<String>(lmpDate.value);
    }
    if (edcDate.present) {
      map['edc_date'] = Variable<String>(edcDate.value);
    }
    if (gravidity.present) {
      map['gravidity'] = Variable<int>(gravidity.value);
    }
    if (parity.present) {
      map['parity'] = Variable<int>(parity.value);
    }
    if (systolicBp.present) {
      map['systolic_bp'] = Variable<int>(systolicBp.value);
    }
    if (diastolicBp.present) {
      map['diastolic_bp'] = Variable<int>(diastolicBp.value);
    }
    if (maternalWeightKg.present) {
      map['maternal_weight_kg'] = Variable<double>(maternalWeightKg.value);
    }
    if (fundicHeightCm.present) {
      map['fundic_height_cm'] = Variable<double>(fundicHeightCm.value);
    }
    if (ironFolicGiven.present) {
      map['iron_folic_given'] = Variable<int>(ironFolicGiven.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaternalCareDetailsCompanion(')
          ..write('encounterUuid: $encounterUuid, ')
          ..write('lmpDate: $lmpDate, ')
          ..write('edcDate: $edcDate, ')
          ..write('gravidity: $gravidity, ')
          ..write('parity: $parity, ')
          ..write('systolicBp: $systolicBp, ')
          ..write('diastolicBp: $diastolicBp, ')
          ..write('maternalWeightKg: $maternalWeightKg, ')
          ..write('fundicHeightCm: $fundicHeightCm, ')
          ..write('ironFolicGiven: $ironFolicGiven, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ImmunizationDetailsTable extends ImmunizationDetails
    with TableInfo<$ImmunizationDetailsTable, ImmunizationDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImmunizationDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _encounterUuidMeta =
      const VerificationMeta('encounterUuid');
  @override
  late final GeneratedColumn<String> encounterUuid = GeneratedColumn<String>(
      'encounter_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES encounters (encounter_uuid)'));
  static const VerificationMeta _antigenCodeMeta =
      const VerificationMeta('antigenCode');
  @override
  late final GeneratedColumn<String> antigenCode = GeneratedColumn<String>(
      'antigen_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doseNumberMeta =
      const VerificationMeta('doseNumber');
  @override
  late final GeneratedColumn<int> doseNumber = GeneratedColumn<int>(
      'dose_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _administrationDateMeta =
      const VerificationMeta('administrationDate');
  @override
  late final GeneratedColumn<String> administrationDate =
      GeneratedColumn<String>('administration_date', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lotNumberMeta =
      const VerificationMeta('lotNumber');
  @override
  late final GeneratedColumn<String> lotNumber = GeneratedColumn<String>(
      'lot_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [encounterUuid, antigenCode, doseNumber, administrationDate, lotNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'immunization_details';
  @override
  VerificationContext validateIntegrity(Insertable<ImmunizationDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('encounter_uuid')) {
      context.handle(
          _encounterUuidMeta,
          encounterUuid.isAcceptableOrUnknown(
              data['encounter_uuid']!, _encounterUuidMeta));
    } else if (isInserting) {
      context.missing(_encounterUuidMeta);
    }
    if (data.containsKey('antigen_code')) {
      context.handle(
          _antigenCodeMeta,
          antigenCode.isAcceptableOrUnknown(
              data['antigen_code']!, _antigenCodeMeta));
    } else if (isInserting) {
      context.missing(_antigenCodeMeta);
    }
    if (data.containsKey('dose_number')) {
      context.handle(
          _doseNumberMeta,
          doseNumber.isAcceptableOrUnknown(
              data['dose_number']!, _doseNumberMeta));
    } else if (isInserting) {
      context.missing(_doseNumberMeta);
    }
    if (data.containsKey('administration_date')) {
      context.handle(
          _administrationDateMeta,
          administrationDate.isAcceptableOrUnknown(
              data['administration_date']!, _administrationDateMeta));
    } else if (isInserting) {
      context.missing(_administrationDateMeta);
    }
    if (data.containsKey('lot_number')) {
      context.handle(_lotNumberMeta,
          lotNumber.isAcceptableOrUnknown(data['lot_number']!, _lotNumberMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {encounterUuid};
  @override
  ImmunizationDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImmunizationDetail(
      encounterUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encounter_uuid'])!,
      antigenCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}antigen_code'])!,
      doseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dose_number'])!,
      administrationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}administration_date'])!,
      lotNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lot_number']),
    );
  }

  @override
  $ImmunizationDetailsTable createAlias(String alias) {
    return $ImmunizationDetailsTable(attachedDatabase, alias);
  }
}

class ImmunizationDetail extends DataClass
    implements Insertable<ImmunizationDetail> {
  final String encounterUuid;
  final String antigenCode;
  final int doseNumber;
  final String administrationDate;
  final String? lotNumber;
  const ImmunizationDetail(
      {required this.encounterUuid,
      required this.antigenCode,
      required this.doseNumber,
      required this.administrationDate,
      this.lotNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['encounter_uuid'] = Variable<String>(encounterUuid);
    map['antigen_code'] = Variable<String>(antigenCode);
    map['dose_number'] = Variable<int>(doseNumber);
    map['administration_date'] = Variable<String>(administrationDate);
    if (!nullToAbsent || lotNumber != null) {
      map['lot_number'] = Variable<String>(lotNumber);
    }
    return map;
  }

  ImmunizationDetailsCompanion toCompanion(bool nullToAbsent) {
    return ImmunizationDetailsCompanion(
      encounterUuid: Value(encounterUuid),
      antigenCode: Value(antigenCode),
      doseNumber: Value(doseNumber),
      administrationDate: Value(administrationDate),
      lotNumber: lotNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(lotNumber),
    );
  }

  factory ImmunizationDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImmunizationDetail(
      encounterUuid: serializer.fromJson<String>(json['encounterUuid']),
      antigenCode: serializer.fromJson<String>(json['antigenCode']),
      doseNumber: serializer.fromJson<int>(json['doseNumber']),
      administrationDate:
          serializer.fromJson<String>(json['administrationDate']),
      lotNumber: serializer.fromJson<String?>(json['lotNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'encounterUuid': serializer.toJson<String>(encounterUuid),
      'antigenCode': serializer.toJson<String>(antigenCode),
      'doseNumber': serializer.toJson<int>(doseNumber),
      'administrationDate': serializer.toJson<String>(administrationDate),
      'lotNumber': serializer.toJson<String?>(lotNumber),
    };
  }

  ImmunizationDetail copyWith(
          {String? encounterUuid,
          String? antigenCode,
          int? doseNumber,
          String? administrationDate,
          Value<String?> lotNumber = const Value.absent()}) =>
      ImmunizationDetail(
        encounterUuid: encounterUuid ?? this.encounterUuid,
        antigenCode: antigenCode ?? this.antigenCode,
        doseNumber: doseNumber ?? this.doseNumber,
        administrationDate: administrationDate ?? this.administrationDate,
        lotNumber: lotNumber.present ? lotNumber.value : this.lotNumber,
      );
  ImmunizationDetail copyWithCompanion(ImmunizationDetailsCompanion data) {
    return ImmunizationDetail(
      encounterUuid: data.encounterUuid.present
          ? data.encounterUuid.value
          : this.encounterUuid,
      antigenCode:
          data.antigenCode.present ? data.antigenCode.value : this.antigenCode,
      doseNumber:
          data.doseNumber.present ? data.doseNumber.value : this.doseNumber,
      administrationDate: data.administrationDate.present
          ? data.administrationDate.value
          : this.administrationDate,
      lotNumber: data.lotNumber.present ? data.lotNumber.value : this.lotNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImmunizationDetail(')
          ..write('encounterUuid: $encounterUuid, ')
          ..write('antigenCode: $antigenCode, ')
          ..write('doseNumber: $doseNumber, ')
          ..write('administrationDate: $administrationDate, ')
          ..write('lotNumber: $lotNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      encounterUuid, antigenCode, doseNumber, administrationDate, lotNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImmunizationDetail &&
          other.encounterUuid == this.encounterUuid &&
          other.antigenCode == this.antigenCode &&
          other.doseNumber == this.doseNumber &&
          other.administrationDate == this.administrationDate &&
          other.lotNumber == this.lotNumber);
}

class ImmunizationDetailsCompanion extends UpdateCompanion<ImmunizationDetail> {
  final Value<String> encounterUuid;
  final Value<String> antigenCode;
  final Value<int> doseNumber;
  final Value<String> administrationDate;
  final Value<String?> lotNumber;
  final Value<int> rowid;
  const ImmunizationDetailsCompanion({
    this.encounterUuid = const Value.absent(),
    this.antigenCode = const Value.absent(),
    this.doseNumber = const Value.absent(),
    this.administrationDate = const Value.absent(),
    this.lotNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImmunizationDetailsCompanion.insert({
    required String encounterUuid,
    required String antigenCode,
    required int doseNumber,
    required String administrationDate,
    this.lotNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : encounterUuid = Value(encounterUuid),
        antigenCode = Value(antigenCode),
        doseNumber = Value(doseNumber),
        administrationDate = Value(administrationDate);
  static Insertable<ImmunizationDetail> custom({
    Expression<String>? encounterUuid,
    Expression<String>? antigenCode,
    Expression<int>? doseNumber,
    Expression<String>? administrationDate,
    Expression<String>? lotNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (encounterUuid != null) 'encounter_uuid': encounterUuid,
      if (antigenCode != null) 'antigen_code': antigenCode,
      if (doseNumber != null) 'dose_number': doseNumber,
      if (administrationDate != null) 'administration_date': administrationDate,
      if (lotNumber != null) 'lot_number': lotNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImmunizationDetailsCompanion copyWith(
      {Value<String>? encounterUuid,
      Value<String>? antigenCode,
      Value<int>? doseNumber,
      Value<String>? administrationDate,
      Value<String?>? lotNumber,
      Value<int>? rowid}) {
    return ImmunizationDetailsCompanion(
      encounterUuid: encounterUuid ?? this.encounterUuid,
      antigenCode: antigenCode ?? this.antigenCode,
      doseNumber: doseNumber ?? this.doseNumber,
      administrationDate: administrationDate ?? this.administrationDate,
      lotNumber: lotNumber ?? this.lotNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (encounterUuid.present) {
      map['encounter_uuid'] = Variable<String>(encounterUuid.value);
    }
    if (antigenCode.present) {
      map['antigen_code'] = Variable<String>(antigenCode.value);
    }
    if (doseNumber.present) {
      map['dose_number'] = Variable<int>(doseNumber.value);
    }
    if (administrationDate.present) {
      map['administration_date'] = Variable<String>(administrationDate.value);
    }
    if (lotNumber.present) {
      map['lot_number'] = Variable<String>(lotNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImmunizationDetailsCompanion(')
          ..write('encounterUuid: $encounterUuid, ')
          ..write('antigenCode: $antigenCode, ')
          ..write('doseNumber: $doseNumber, ')
          ..write('administrationDate: $administrationDate, ')
          ..write('lotNumber: $lotNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NutritionLogsTable extends NutritionLogs
    with TableInfo<$NutritionLogsTable, NutritionLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutritionLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _encounterUuidMeta =
      const VerificationMeta('encounterUuid');
  @override
  late final GeneratedColumn<String> encounterUuid = GeneratedColumn<String>(
      'encounter_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES encounters (encounter_uuid)'));
  static const VerificationMeta _ageMonthsMeta =
      const VerificationMeta('ageMonths');
  @override
  late final GeneratedColumn<int> ageMonths = GeneratedColumn<int>(
      'age_months', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _heightCmMeta =
      const VerificationMeta('heightCm');
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
      'height_cm', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _postureMeta =
      const VerificationMeta('posture');
  @override
  late final GeneratedColumn<String> posture = GeneratedColumn<String>(
      'posture', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _edemaMeta = const VerificationMeta('edema');
  @override
  late final GeneratedColumn<int> edema = GeneratedColumn<int>(
      'edema', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _whzScoreMeta =
      const VerificationMeta('whzScore');
  @override
  late final GeneratedColumn<double> whzScore = GeneratedColumn<double>(
      'whz_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _hazScoreMeta =
      const VerificationMeta('hazScore');
  @override
  late final GeneratedColumn<double> hazScore = GeneratedColumn<double>(
      'haz_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _wazScoreMeta =
      const VerificationMeta('wazScore');
  @override
  late final GeneratedColumn<double> wazScore = GeneratedColumn<double>(
      'waz_score', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _nutritionalStatusMeta =
      const VerificationMeta('nutritionalStatus');
  @override
  late final GeneratedColumn<String> nutritionalStatus =
      GeneratedColumn<String>('nutritional_status', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        encounterUuid,
        ageMonths,
        weightKg,
        heightCm,
        posture,
        edema,
        whzScore,
        hazScore,
        wazScore,
        nutritionalStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrition_logs';
  @override
  VerificationContext validateIntegrity(Insertable<NutritionLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('encounter_uuid')) {
      context.handle(
          _encounterUuidMeta,
          encounterUuid.isAcceptableOrUnknown(
              data['encounter_uuid']!, _encounterUuidMeta));
    } else if (isInserting) {
      context.missing(_encounterUuidMeta);
    }
    if (data.containsKey('age_months')) {
      context.handle(_ageMonthsMeta,
          ageMonths.isAcceptableOrUnknown(data['age_months']!, _ageMonthsMeta));
    } else if (isInserting) {
      context.missing(_ageMonthsMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(_heightCmMeta,
          heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta));
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('posture')) {
      context.handle(_postureMeta,
          posture.isAcceptableOrUnknown(data['posture']!, _postureMeta));
    } else if (isInserting) {
      context.missing(_postureMeta);
    }
    if (data.containsKey('edema')) {
      context.handle(
          _edemaMeta, edema.isAcceptableOrUnknown(data['edema']!, _edemaMeta));
    } else if (isInserting) {
      context.missing(_edemaMeta);
    }
    if (data.containsKey('whz_score')) {
      context.handle(_whzScoreMeta,
          whzScore.isAcceptableOrUnknown(data['whz_score']!, _whzScoreMeta));
    } else if (isInserting) {
      context.missing(_whzScoreMeta);
    }
    if (data.containsKey('haz_score')) {
      context.handle(_hazScoreMeta,
          hazScore.isAcceptableOrUnknown(data['haz_score']!, _hazScoreMeta));
    } else if (isInserting) {
      context.missing(_hazScoreMeta);
    }
    if (data.containsKey('waz_score')) {
      context.handle(_wazScoreMeta,
          wazScore.isAcceptableOrUnknown(data['waz_score']!, _wazScoreMeta));
    } else if (isInserting) {
      context.missing(_wazScoreMeta);
    }
    if (data.containsKey('nutritional_status')) {
      context.handle(
          _nutritionalStatusMeta,
          nutritionalStatus.isAcceptableOrUnknown(
              data['nutritional_status']!, _nutritionalStatusMeta));
    } else if (isInserting) {
      context.missing(_nutritionalStatusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {encounterUuid};
  @override
  NutritionLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutritionLog(
      encounterUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}encounter_uuid'])!,
      ageMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age_months'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      heightCm: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height_cm'])!,
      posture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}posture'])!,
      edema: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}edema'])!,
      whzScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}whz_score'])!,
      hazScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}haz_score'])!,
      wazScore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}waz_score'])!,
      nutritionalStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}nutritional_status'])!,
    );
  }

  @override
  $NutritionLogsTable createAlias(String alias) {
    return $NutritionLogsTable(attachedDatabase, alias);
  }
}

class NutritionLog extends DataClass implements Insertable<NutritionLog> {
  final String encounterUuid;
  final int ageMonths;
  final double weightKg;
  final double heightCm;
  final String posture;
  final int edema;
  final double whzScore;
  final double hazScore;
  final double wazScore;
  final String nutritionalStatus;
  const NutritionLog(
      {required this.encounterUuid,
      required this.ageMonths,
      required this.weightKg,
      required this.heightCm,
      required this.posture,
      required this.edema,
      required this.whzScore,
      required this.hazScore,
      required this.wazScore,
      required this.nutritionalStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['encounter_uuid'] = Variable<String>(encounterUuid);
    map['age_months'] = Variable<int>(ageMonths);
    map['weight_kg'] = Variable<double>(weightKg);
    map['height_cm'] = Variable<double>(heightCm);
    map['posture'] = Variable<String>(posture);
    map['edema'] = Variable<int>(edema);
    map['whz_score'] = Variable<double>(whzScore);
    map['haz_score'] = Variable<double>(hazScore);
    map['waz_score'] = Variable<double>(wazScore);
    map['nutritional_status'] = Variable<String>(nutritionalStatus);
    return map;
  }

  NutritionLogsCompanion toCompanion(bool nullToAbsent) {
    return NutritionLogsCompanion(
      encounterUuid: Value(encounterUuid),
      ageMonths: Value(ageMonths),
      weightKg: Value(weightKg),
      heightCm: Value(heightCm),
      posture: Value(posture),
      edema: Value(edema),
      whzScore: Value(whzScore),
      hazScore: Value(hazScore),
      wazScore: Value(wazScore),
      nutritionalStatus: Value(nutritionalStatus),
    );
  }

  factory NutritionLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutritionLog(
      encounterUuid: serializer.fromJson<String>(json['encounterUuid']),
      ageMonths: serializer.fromJson<int>(json['ageMonths']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      posture: serializer.fromJson<String>(json['posture']),
      edema: serializer.fromJson<int>(json['edema']),
      whzScore: serializer.fromJson<double>(json['whzScore']),
      hazScore: serializer.fromJson<double>(json['hazScore']),
      wazScore: serializer.fromJson<double>(json['wazScore']),
      nutritionalStatus: serializer.fromJson<String>(json['nutritionalStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'encounterUuid': serializer.toJson<String>(encounterUuid),
      'ageMonths': serializer.toJson<int>(ageMonths),
      'weightKg': serializer.toJson<double>(weightKg),
      'heightCm': serializer.toJson<double>(heightCm),
      'posture': serializer.toJson<String>(posture),
      'edema': serializer.toJson<int>(edema),
      'whzScore': serializer.toJson<double>(whzScore),
      'hazScore': serializer.toJson<double>(hazScore),
      'wazScore': serializer.toJson<double>(wazScore),
      'nutritionalStatus': serializer.toJson<String>(nutritionalStatus),
    };
  }

  NutritionLog copyWith(
          {String? encounterUuid,
          int? ageMonths,
          double? weightKg,
          double? heightCm,
          String? posture,
          int? edema,
          double? whzScore,
          double? hazScore,
          double? wazScore,
          String? nutritionalStatus}) =>
      NutritionLog(
        encounterUuid: encounterUuid ?? this.encounterUuid,
        ageMonths: ageMonths ?? this.ageMonths,
        weightKg: weightKg ?? this.weightKg,
        heightCm: heightCm ?? this.heightCm,
        posture: posture ?? this.posture,
        edema: edema ?? this.edema,
        whzScore: whzScore ?? this.whzScore,
        hazScore: hazScore ?? this.hazScore,
        wazScore: wazScore ?? this.wazScore,
        nutritionalStatus: nutritionalStatus ?? this.nutritionalStatus,
      );
  NutritionLog copyWithCompanion(NutritionLogsCompanion data) {
    return NutritionLog(
      encounterUuid: data.encounterUuid.present
          ? data.encounterUuid.value
          : this.encounterUuid,
      ageMonths: data.ageMonths.present ? data.ageMonths.value : this.ageMonths,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      posture: data.posture.present ? data.posture.value : this.posture,
      edema: data.edema.present ? data.edema.value : this.edema,
      whzScore: data.whzScore.present ? data.whzScore.value : this.whzScore,
      hazScore: data.hazScore.present ? data.hazScore.value : this.hazScore,
      wazScore: data.wazScore.present ? data.wazScore.value : this.wazScore,
      nutritionalStatus: data.nutritionalStatus.present
          ? data.nutritionalStatus.value
          : this.nutritionalStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutritionLog(')
          ..write('encounterUuid: $encounterUuid, ')
          ..write('ageMonths: $ageMonths, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('posture: $posture, ')
          ..write('edema: $edema, ')
          ..write('whzScore: $whzScore, ')
          ..write('hazScore: $hazScore, ')
          ..write('wazScore: $wazScore, ')
          ..write('nutritionalStatus: $nutritionalStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(encounterUuid, ageMonths, weightKg, heightCm,
      posture, edema, whzScore, hazScore, wazScore, nutritionalStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutritionLog &&
          other.encounterUuid == this.encounterUuid &&
          other.ageMonths == this.ageMonths &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.posture == this.posture &&
          other.edema == this.edema &&
          other.whzScore == this.whzScore &&
          other.hazScore == this.hazScore &&
          other.wazScore == this.wazScore &&
          other.nutritionalStatus == this.nutritionalStatus);
}

class NutritionLogsCompanion extends UpdateCompanion<NutritionLog> {
  final Value<String> encounterUuid;
  final Value<int> ageMonths;
  final Value<double> weightKg;
  final Value<double> heightCm;
  final Value<String> posture;
  final Value<int> edema;
  final Value<double> whzScore;
  final Value<double> hazScore;
  final Value<double> wazScore;
  final Value<String> nutritionalStatus;
  final Value<int> rowid;
  const NutritionLogsCompanion({
    this.encounterUuid = const Value.absent(),
    this.ageMonths = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.posture = const Value.absent(),
    this.edema = const Value.absent(),
    this.whzScore = const Value.absent(),
    this.hazScore = const Value.absent(),
    this.wazScore = const Value.absent(),
    this.nutritionalStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NutritionLogsCompanion.insert({
    required String encounterUuid,
    required int ageMonths,
    required double weightKg,
    required double heightCm,
    required String posture,
    required int edema,
    required double whzScore,
    required double hazScore,
    required double wazScore,
    required String nutritionalStatus,
    this.rowid = const Value.absent(),
  })  : encounterUuid = Value(encounterUuid),
        ageMonths = Value(ageMonths),
        weightKg = Value(weightKg),
        heightCm = Value(heightCm),
        posture = Value(posture),
        edema = Value(edema),
        whzScore = Value(whzScore),
        hazScore = Value(hazScore),
        wazScore = Value(wazScore),
        nutritionalStatus = Value(nutritionalStatus);
  static Insertable<NutritionLog> custom({
    Expression<String>? encounterUuid,
    Expression<int>? ageMonths,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<String>? posture,
    Expression<int>? edema,
    Expression<double>? whzScore,
    Expression<double>? hazScore,
    Expression<double>? wazScore,
    Expression<String>? nutritionalStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (encounterUuid != null) 'encounter_uuid': encounterUuid,
      if (ageMonths != null) 'age_months': ageMonths,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (posture != null) 'posture': posture,
      if (edema != null) 'edema': edema,
      if (whzScore != null) 'whz_score': whzScore,
      if (hazScore != null) 'haz_score': hazScore,
      if (wazScore != null) 'waz_score': wazScore,
      if (nutritionalStatus != null) 'nutritional_status': nutritionalStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NutritionLogsCompanion copyWith(
      {Value<String>? encounterUuid,
      Value<int>? ageMonths,
      Value<double>? weightKg,
      Value<double>? heightCm,
      Value<String>? posture,
      Value<int>? edema,
      Value<double>? whzScore,
      Value<double>? hazScore,
      Value<double>? wazScore,
      Value<String>? nutritionalStatus,
      Value<int>? rowid}) {
    return NutritionLogsCompanion(
      encounterUuid: encounterUuid ?? this.encounterUuid,
      ageMonths: ageMonths ?? this.ageMonths,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      posture: posture ?? this.posture,
      edema: edema ?? this.edema,
      whzScore: whzScore ?? this.whzScore,
      hazScore: hazScore ?? this.hazScore,
      wazScore: wazScore ?? this.wazScore,
      nutritionalStatus: nutritionalStatus ?? this.nutritionalStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (encounterUuid.present) {
      map['encounter_uuid'] = Variable<String>(encounterUuid.value);
    }
    if (ageMonths.present) {
      map['age_months'] = Variable<int>(ageMonths.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (posture.present) {
      map['posture'] = Variable<String>(posture.value);
    }
    if (edema.present) {
      map['edema'] = Variable<int>(edema.value);
    }
    if (whzScore.present) {
      map['whz_score'] = Variable<double>(whzScore.value);
    }
    if (hazScore.present) {
      map['haz_score'] = Variable<double>(hazScore.value);
    }
    if (wazScore.present) {
      map['waz_score'] = Variable<double>(wazScore.value);
    }
    if (nutritionalStatus.present) {
      map['nutritional_status'] = Variable<String>(nutritionalStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutritionLogsCompanion(')
          ..write('encounterUuid: $encounterUuid, ')
          ..write('ageMonths: $ageMonths, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('posture: $posture, ')
          ..write('edema: $edema, ')
          ..write('whzScore: $whzScore, ')
          ..write('hazScore: $hazScore, ')
          ..write('wazScore: $wazScore, ')
          ..write('nutritionalStatus: $nutritionalStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queueIdMeta =
      const VerificationMeta('queueId');
  @override
  late final GeneratedColumn<int> queueId = GeneratedColumn<int>(
      'queue_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _entityUuidMeta =
      const VerificationMeta('entityUuid');
  @override
  late final GeneratedColumn<String> entityUuid = GeneratedColumn<String>(
      'entity_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationTypeMeta =
      const VerificationMeta('operationType');
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
      'operation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<String> syncedAt = GeneratedColumn<String>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        queueId,
        entityUuid,
        entityType,
        operationType,
        payloadJson,
        syncStatus,
        retryCount,
        createdAt,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('queue_id')) {
      context.handle(_queueIdMeta,
          queueId.isAcceptableOrUnknown(data['queue_id']!, _queueIdMeta));
    }
    if (data.containsKey('entity_uuid')) {
      context.handle(
          _entityUuidMeta,
          entityUuid.isAcceptableOrUnknown(
              data['entity_uuid']!, _entityUuidMeta));
    } else if (isInserting) {
      context.missing(_entityUuidMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('operation_type')) {
      context.handle(
          _operationTypeMeta,
          operationType.isAcceptableOrUnknown(
              data['operation_type']!, _operationTypeMeta));
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {queueId};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      queueId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}queue_id'])!,
      entityUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_uuid'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      operationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation_type'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int queueId;
  final String entityUuid;
  final String entityType;
  final String operationType;
  final String payloadJson;
  final String syncStatus;
  final int retryCount;
  final String createdAt;
  final String? syncedAt;
  const SyncQueueData(
      {required this.queueId,
      required this.entityUuid,
      required this.entityType,
      required this.operationType,
      required this.payloadJson,
      required this.syncStatus,
      required this.retryCount,
      required this.createdAt,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['queue_id'] = Variable<int>(queueId);
    map['entity_uuid'] = Variable<String>(entityUuid);
    map['entity_type'] = Variable<String>(entityType);
    map['operation_type'] = Variable<String>(operationType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['sync_status'] = Variable<String>(syncStatus);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<String>(syncedAt);
    }
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      queueId: Value(queueId),
      entityUuid: Value(entityUuid),
      entityType: Value(entityType),
      operationType: Value(operationType),
      payloadJson: Value(payloadJson),
      syncStatus: Value(syncStatus),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      queueId: serializer.fromJson<int>(json['queueId']),
      entityUuid: serializer.fromJson<String>(json['entityUuid']),
      entityType: serializer.fromJson<String>(json['entityType']),
      operationType: serializer.fromJson<String>(json['operationType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      syncedAt: serializer.fromJson<String?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'queueId': serializer.toJson<int>(queueId),
      'entityUuid': serializer.toJson<String>(entityUuid),
      'entityType': serializer.toJson<String>(entityType),
      'operationType': serializer.toJson<String>(operationType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<String>(createdAt),
      'syncedAt': serializer.toJson<String?>(syncedAt),
    };
  }

  SyncQueueData copyWith(
          {int? queueId,
          String? entityUuid,
          String? entityType,
          String? operationType,
          String? payloadJson,
          String? syncStatus,
          int? retryCount,
          String? createdAt,
          Value<String?> syncedAt = const Value.absent()}) =>
      SyncQueueData(
        queueId: queueId ?? this.queueId,
        entityUuid: entityUuid ?? this.entityUuid,
        entityType: entityType ?? this.entityType,
        operationType: operationType ?? this.operationType,
        payloadJson: payloadJson ?? this.payloadJson,
        syncStatus: syncStatus ?? this.syncStatus,
        retryCount: retryCount ?? this.retryCount,
        createdAt: createdAt ?? this.createdAt,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      queueId: data.queueId.present ? data.queueId.value : this.queueId,
      entityUuid:
          data.entityUuid.present ? data.entityUuid.value : this.entityUuid,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('queueId: $queueId, ')
          ..write('entityUuid: $entityUuid, ')
          ..write('entityType: $entityType, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(queueId, entityUuid, entityType,
      operationType, payloadJson, syncStatus, retryCount, createdAt, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.queueId == this.queueId &&
          other.entityUuid == this.entityUuid &&
          other.entityType == this.entityType &&
          other.operationType == this.operationType &&
          other.payloadJson == this.payloadJson &&
          other.syncStatus == this.syncStatus &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> queueId;
  final Value<String> entityUuid;
  final Value<String> entityType;
  final Value<String> operationType;
  final Value<String> payloadJson;
  final Value<String> syncStatus;
  final Value<int> retryCount;
  final Value<String> createdAt;
  final Value<String?> syncedAt;
  const SyncQueueCompanion({
    this.queueId = const Value.absent(),
    this.entityUuid = const Value.absent(),
    this.entityType = const Value.absent(),
    this.operationType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.queueId = const Value.absent(),
    required String entityUuid,
    required String entityType,
    required String operationType,
    required String payloadJson,
    required String syncStatus,
    this.retryCount = const Value.absent(),
    required String createdAt,
    this.syncedAt = const Value.absent(),
  })  : entityUuid = Value(entityUuid),
        entityType = Value(entityType),
        operationType = Value(operationType),
        payloadJson = Value(payloadJson),
        syncStatus = Value(syncStatus),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? queueId,
    Expression<String>? entityUuid,
    Expression<String>? entityType,
    Expression<String>? operationType,
    Expression<String>? payloadJson,
    Expression<String>? syncStatus,
    Expression<int>? retryCount,
    Expression<String>? createdAt,
    Expression<String>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (queueId != null) 'queue_id': queueId,
      if (entityUuid != null) 'entity_uuid': entityUuid,
      if (entityType != null) 'entity_type': entityType,
      if (operationType != null) 'operation_type': operationType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? queueId,
      Value<String>? entityUuid,
      Value<String>? entityType,
      Value<String>? operationType,
      Value<String>? payloadJson,
      Value<String>? syncStatus,
      Value<int>? retryCount,
      Value<String>? createdAt,
      Value<String?>? syncedAt}) {
    return SyncQueueCompanion(
      queueId: queueId ?? this.queueId,
      entityUuid: entityUuid ?? this.entityUuid,
      entityType: entityType ?? this.entityType,
      operationType: operationType ?? this.operationType,
      payloadJson: payloadJson ?? this.payloadJson,
      syncStatus: syncStatus ?? this.syncStatus,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (queueId.present) {
      map['queue_id'] = Variable<int>(queueId.value);
    }
    if (entityUuid.present) {
      map['entity_uuid'] = Variable<String>(entityUuid.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<String>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('queueId: $queueId, ')
          ..write('entityUuid: $entityUuid, ')
          ..write('entityType: $entityType, ')
          ..write('operationType: $operationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HouseholdsTable households = $HouseholdsTable(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $EncountersTable encounters = $EncountersTable(this);
  late final $MaternalCareDetailsTable maternalCareDetails =
      $MaternalCareDetailsTable(this);
  late final $ImmunizationDetailsTable immunizationDetails =
      $ImmunizationDetailsTable(this);
  late final $NutritionLogsTable nutritionLogs = $NutritionLogsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        households,
        patients,
        encounters,
        maternalCareDetails,
        immunizationDetails,
        nutritionLogs,
        syncQueue
      ];
}

typedef $$HouseholdsTableCreateCompanionBuilder = HouseholdsCompanion Function({
  required String householdUuid,
  required String sitioName,
  required String dwellingType,
  required int waterSourceCode,
  required int sanitationFacilityCode,
  Value<double?> latitude,
  Value<double?> longitude,
  required String createdAt,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$HouseholdsTableUpdateCompanionBuilder = HouseholdsCompanion Function({
  Value<String> householdUuid,
  Value<String> sitioName,
  Value<String> dwellingType,
  Value<int> waterSourceCode,
  Value<int> sanitationFacilityCode,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<int> rowid,
});

final class $$HouseholdsTableReferences
    extends BaseReferences<_$AppDatabase, $HouseholdsTable, Household> {
  $$HouseholdsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PatientsTable, List<Patient>> _patientsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.patients,
          aliasName: 'households__household_uuid__patients__household_uuid');

  $$PatientsTableProcessedTableManager get patientsRefs {
    final manager = $$PatientsTableTableManager($_db, $_db.patients).filter(
        (f) => f.householdUuid.householdUuid
            .sqlEquals($_itemColumn<String>('household_uuid')!));

    final cache = $_typedResult.readTableOrNull(_patientsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HouseholdsTableFilterComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get householdUuid => $composableBuilder(
      column: $table.householdUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sitioName => $composableBuilder(
      column: $table.sitioName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dwellingType => $composableBuilder(
      column: $table.dwellingType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get waterSourceCode => $composableBuilder(
      column: $table.waterSourceCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sanitationFacilityCode => $composableBuilder(
      column: $table.sanitationFacilityCode,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> patientsRefs(
      Expression<bool> Function($$PatientsTableFilterComposer f) f) {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdUuid,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.householdUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HouseholdsTableOrderingComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get householdUuid => $composableBuilder(
      column: $table.householdUuid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sitioName => $composableBuilder(
      column: $table.sitioName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dwellingType => $composableBuilder(
      column: $table.dwellingType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get waterSourceCode => $composableBuilder(
      column: $table.waterSourceCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sanitationFacilityCode => $composableBuilder(
      column: $table.sanitationFacilityCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HouseholdsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HouseholdsTable> {
  $$HouseholdsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get householdUuid => $composableBuilder(
      column: $table.householdUuid, builder: (column) => column);

  GeneratedColumn<String> get sitioName =>
      $composableBuilder(column: $table.sitioName, builder: (column) => column);

  GeneratedColumn<String> get dwellingType => $composableBuilder(
      column: $table.dwellingType, builder: (column) => column);

  GeneratedColumn<int> get waterSourceCode => $composableBuilder(
      column: $table.waterSourceCode, builder: (column) => column);

  GeneratedColumn<int> get sanitationFacilityCode => $composableBuilder(
      column: $table.sanitationFacilityCode, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> patientsRefs<T extends Object>(
      Expression<T> Function($$PatientsTableAnnotationComposer a) f) {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdUuid,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.householdUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HouseholdsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    Household,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (Household, $$HouseholdsTableReferences),
    Household,
    PrefetchHooks Function({bool patientsRefs})> {
  $$HouseholdsTableTableManager(_$AppDatabase db, $HouseholdsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HouseholdsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HouseholdsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HouseholdsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> householdUuid = const Value.absent(),
            Value<String> sitioName = const Value.absent(),
            Value<String> dwellingType = const Value.absent(),
            Value<int> waterSourceCode = const Value.absent(),
            Value<int> sanitationFacilityCode = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdsCompanion(
            householdUuid: householdUuid,
            sitioName: sitioName,
            dwellingType: dwellingType,
            waterSourceCode: waterSourceCode,
            sanitationFacilityCode: sanitationFacilityCode,
            latitude: latitude,
            longitude: longitude,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String householdUuid,
            required String sitioName,
            required String dwellingType,
            required int waterSourceCode,
            required int sanitationFacilityCode,
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HouseholdsCompanion.insert(
            householdUuid: householdUuid,
            sitioName: sitioName,
            dwellingType: dwellingType,
            waterSourceCode: waterSourceCode,
            sanitationFacilityCode: sanitationFacilityCode,
            latitude: latitude,
            longitude: longitude,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$HouseholdsTable, Household>(table),
                    $$HouseholdsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({patientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (patientsRefs) db.patients],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (patientsRefs)
                    await $_getPrefetchedData<Household, $HouseholdsTable,
                            Patient>(
                        currentTable: table,
                        referencedTable:
                            $$HouseholdsTableReferences._patientsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HouseholdsTableReferences(db, table, p0)
                                .patientsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.householdUuid == item.householdUuid),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HouseholdsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HouseholdsTable,
    Household,
    $$HouseholdsTableFilterComposer,
    $$HouseholdsTableOrderingComposer,
    $$HouseholdsTableAnnotationComposer,
    $$HouseholdsTableCreateCompanionBuilder,
    $$HouseholdsTableUpdateCompanionBuilder,
    (Household, $$HouseholdsTableReferences),
    Household,
    PrefetchHooks Function({bool patientsRefs})>;
typedef $$PatientsTableCreateCompanionBuilder = PatientsCompanion Function({
  required String patientUuid,
  required String householdUuid,
  required String firstName,
  required String lastName,
  required String birthdate,
  required String sex,
  Value<String?> philhealthId,
  Value<int> isActive,
  required String createdAt,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$PatientsTableUpdateCompanionBuilder = PatientsCompanion Function({
  Value<String> patientUuid,
  Value<String> householdUuid,
  Value<String> firstName,
  Value<String> lastName,
  Value<String> birthdate,
  Value<String> sex,
  Value<String?> philhealthId,
  Value<int> isActive,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<int> rowid,
});

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, Patient> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HouseholdsTable _householdUuidTable(_$AppDatabase db) => db.households
      .createAlias('patients__household_uuid__households__household_uuid');

  $$HouseholdsTableProcessedTableManager get householdUuid {
    final $_column = $_itemColumn<String>('household_uuid')!;

    final manager = $$HouseholdsTableTableManager($_db, $_db.households)
        .filter((f) => f.householdUuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EncountersTable, List<Encounter>>
      _encountersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.encounters,
              aliasName: 'patients__patient_uuid__encounters__patient_uuid');

  $$EncountersTableProcessedTableManager get encountersRefs {
    final manager = $$EncountersTableTableManager($_db, $_db.encounters).filter(
        (f) => f.patientUuid.patientUuid
            .sqlEquals($_itemColumn<String>('patient_uuid')!));

    final cache = $_typedResult.readTableOrNull(_encountersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get patientUuid => $composableBuilder(
      column: $table.patientUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthdate => $composableBuilder(
      column: $table.birthdate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get philhealthId => $composableBuilder(
      column: $table.philhealthId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$HouseholdsTableFilterComposer get householdUuid {
    final $$HouseholdsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdUuid,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.householdUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableFilterComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> encountersRefs(
      Expression<bool> Function($$EncountersTableFilterComposer f) f) {
    final $$EncountersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.patientUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableFilterComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get patientUuid => $composableBuilder(
      column: $table.patientUuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get birthdate => $composableBuilder(
      column: $table.birthdate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get philhealthId => $composableBuilder(
      column: $table.philhealthId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$HouseholdsTableOrderingComposer get householdUuid {
    final $$HouseholdsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdUuid,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.householdUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableOrderingComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get patientUuid => $composableBuilder(
      column: $table.patientUuid, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get birthdate =>
      $composableBuilder(column: $table.birthdate, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get philhealthId => $composableBuilder(
      column: $table.philhealthId, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HouseholdsTableAnnotationComposer get householdUuid {
    final $$HouseholdsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.householdUuid,
        referencedTable: $db.households,
        getReferencedColumn: (t) => t.householdUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HouseholdsTableAnnotationComposer(
              $db: $db,
              $table: $db.households,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> encountersRefs<T extends Object>(
      Expression<T> Function($$EncountersTableAnnotationComposer a) f) {
    final $$EncountersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.patientUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableAnnotationComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PatientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, $$PatientsTableReferences),
    Patient,
    PrefetchHooks Function({bool householdUuid, bool encountersRefs})> {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> patientUuid = const Value.absent(),
            Value<String> householdUuid = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String> birthdate = const Value.absent(),
            Value<String> sex = const Value.absent(),
            Value<String?> philhealthId = const Value.absent(),
            Value<int> isActive = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion(
            patientUuid: patientUuid,
            householdUuid: householdUuid,
            firstName: firstName,
            lastName: lastName,
            birthdate: birthdate,
            sex: sex,
            philhealthId: philhealthId,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String patientUuid,
            required String householdUuid,
            required String firstName,
            required String lastName,
            required String birthdate,
            required String sex,
            Value<String?> philhealthId = const Value.absent(),
            Value<int> isActive = const Value.absent(),
            required String createdAt,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientsCompanion.insert(
            patientUuid: patientUuid,
            householdUuid: householdUuid,
            firstName: firstName,
            lastName: lastName,
            birthdate: birthdate,
            sex: sex,
            philhealthId: philhealthId,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PatientsTable, Patient>(table),
                    $$PatientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {householdUuid = false, encountersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (encountersRefs) db.encounters],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (householdUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.householdUuid,
                    referencedTable:
                        $$PatientsTableReferences._householdUuidTable(db),
                    referencedColumn: $$PatientsTableReferences
                        ._householdUuidTable(db)
                        .householdUuid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (encountersRefs)
                    await $_getPrefetchedData<Patient, $PatientsTable,
                            Encounter>(
                        currentTable: table,
                        referencedTable:
                            $$PatientsTableReferences._encountersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PatientsTableReferences(db, table, p0)
                                .encountersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.patientUuid == item.patientUuid),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PatientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientsTable,
    Patient,
    $$PatientsTableFilterComposer,
    $$PatientsTableOrderingComposer,
    $$PatientsTableAnnotationComposer,
    $$PatientsTableCreateCompanionBuilder,
    $$PatientsTableUpdateCompanionBuilder,
    (Patient, $$PatientsTableReferences),
    Patient,
    PrefetchHooks Function({bool householdUuid, bool encountersRefs})>;
typedef $$EncountersTableCreateCompanionBuilder = EncountersCompanion Function({
  required String encounterUuid,
  required String patientUuid,
  required String bhwUserId,
  required String encounterType,
  required String encounterTimestamp,
  required String triageRiskLevel,
  Value<String?> clinicalNotes,
  required String createdAt,
  Value<int> rowid,
});
typedef $$EncountersTableUpdateCompanionBuilder = EncountersCompanion Function({
  Value<String> encounterUuid,
  Value<String> patientUuid,
  Value<String> bhwUserId,
  Value<String> encounterType,
  Value<String> encounterTimestamp,
  Value<String> triageRiskLevel,
  Value<String?> clinicalNotes,
  Value<String> createdAt,
  Value<int> rowid,
});

final class $$EncountersTableReferences
    extends BaseReferences<_$AppDatabase, $EncountersTable, Encounter> {
  $$EncountersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientUuidTable(_$AppDatabase db) => db.patients
      .createAlias('encounters__patient_uuid__patients__patient_uuid');

  $$PatientsTableProcessedTableManager get patientUuid {
    final $_column = $_itemColumn<String>('patient_uuid')!;

    final manager = $$PatientsTableTableManager($_db, $_db.patients)
        .filter((f) => f.patientUuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MaternalCareDetailsTable,
      List<MaternalCareDetail>> _maternalCareDetailsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.maternalCareDetails,
          aliasName:
              'encounters__encounter_uuid__maternal_care_details__encounter_uuid');

  $$MaternalCareDetailsTableProcessedTableManager get maternalCareDetailsRefs {
    final manager =
        $$MaternalCareDetailsTableTableManager($_db, $_db.maternalCareDetails)
            .filter((f) => f.encounterUuid.encounterUuid
                .sqlEquals($_itemColumn<String>('encounter_uuid')!));

    final cache =
        $_typedResult.readTableOrNull(_maternalCareDetailsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ImmunizationDetailsTable,
      List<ImmunizationDetail>> _immunizationDetailsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.immunizationDetails,
          aliasName:
              'encounters__encounter_uuid__immunization_details__encounter_uuid');

  $$ImmunizationDetailsTableProcessedTableManager get immunizationDetailsRefs {
    final manager =
        $$ImmunizationDetailsTableTableManager($_db, $_db.immunizationDetails)
            .filter((f) => f.encounterUuid.encounterUuid
                .sqlEquals($_itemColumn<String>('encounter_uuid')!));

    final cache =
        $_typedResult.readTableOrNull(_immunizationDetailsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NutritionLogsTable, List<NutritionLog>>
      _nutritionLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.nutritionLogs,
              aliasName:
                  'encounters__encounter_uuid__nutrition_logs__encounter_uuid');

  $$NutritionLogsTableProcessedTableManager get nutritionLogsRefs {
    final manager = $$NutritionLogsTableTableManager($_db, $_db.nutritionLogs)
        .filter((f) => f.encounterUuid.encounterUuid
            .sqlEquals($_itemColumn<String>('encounter_uuid')!));

    final cache = $_typedResult.readTableOrNull(_nutritionLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EncountersTableFilterComposer
    extends Composer<_$AppDatabase, $EncountersTable> {
  $$EncountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get encounterUuid => $composableBuilder(
      column: $table.encounterUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bhwUserId => $composableBuilder(
      column: $table.bhwUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encounterType => $composableBuilder(
      column: $table.encounterType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encounterTimestamp => $composableBuilder(
      column: $table.encounterTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get triageRiskLevel => $composableBuilder(
      column: $table.triageRiskLevel,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clinicalNotes => $composableBuilder(
      column: $table.clinicalNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PatientsTableFilterComposer get patientUuid {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientUuid,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.patientUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableFilterComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> maternalCareDetailsRefs(
      Expression<bool> Function($$MaternalCareDetailsTableFilterComposer f) f) {
    final $$MaternalCareDetailsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.maternalCareDetails,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MaternalCareDetailsTableFilterComposer(
              $db: $db,
              $table: $db.maternalCareDetails,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> immunizationDetailsRefs(
      Expression<bool> Function($$ImmunizationDetailsTableFilterComposer f) f) {
    final $$ImmunizationDetailsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.immunizationDetails,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ImmunizationDetailsTableFilterComposer(
              $db: $db,
              $table: $db.immunizationDetails,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> nutritionLogsRefs(
      Expression<bool> Function($$NutritionLogsTableFilterComposer f) f) {
    final $$NutritionLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.nutritionLogs,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NutritionLogsTableFilterComposer(
              $db: $db,
              $table: $db.nutritionLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EncountersTableOrderingComposer
    extends Composer<_$AppDatabase, $EncountersTable> {
  $$EncountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get encounterUuid => $composableBuilder(
      column: $table.encounterUuid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bhwUserId => $composableBuilder(
      column: $table.bhwUserId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encounterType => $composableBuilder(
      column: $table.encounterType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encounterTimestamp => $composableBuilder(
      column: $table.encounterTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get triageRiskLevel => $composableBuilder(
      column: $table.triageRiskLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clinicalNotes => $composableBuilder(
      column: $table.clinicalNotes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PatientsTableOrderingComposer get patientUuid {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientUuid,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.patientUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableOrderingComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EncountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $EncountersTable> {
  $$EncountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get encounterUuid => $composableBuilder(
      column: $table.encounterUuid, builder: (column) => column);

  GeneratedColumn<String> get bhwUserId =>
      $composableBuilder(column: $table.bhwUserId, builder: (column) => column);

  GeneratedColumn<String> get encounterType => $composableBuilder(
      column: $table.encounterType, builder: (column) => column);

  GeneratedColumn<String> get encounterTimestamp => $composableBuilder(
      column: $table.encounterTimestamp, builder: (column) => column);

  GeneratedColumn<String> get triageRiskLevel => $composableBuilder(
      column: $table.triageRiskLevel, builder: (column) => column);

  GeneratedColumn<String> get clinicalNotes => $composableBuilder(
      column: $table.clinicalNotes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientUuid {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.patientUuid,
        referencedTable: $db.patients,
        getReferencedColumn: (t) => t.patientUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PatientsTableAnnotationComposer(
              $db: $db,
              $table: $db.patients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> maternalCareDetailsRefs<T extends Object>(
      Expression<T> Function($$MaternalCareDetailsTableAnnotationComposer a)
          f) {
    final $$MaternalCareDetailsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.encounterUuid,
            referencedTable: $db.maternalCareDetails,
            getReferencedColumn: (t) => t.encounterUuid,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MaternalCareDetailsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.maternalCareDetails,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> immunizationDetailsRefs<T extends Object>(
      Expression<T> Function($$ImmunizationDetailsTableAnnotationComposer a)
          f) {
    final $$ImmunizationDetailsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.encounterUuid,
            referencedTable: $db.immunizationDetails,
            getReferencedColumn: (t) => t.encounterUuid,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ImmunizationDetailsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.immunizationDetails,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> nutritionLogsRefs<T extends Object>(
      Expression<T> Function($$NutritionLogsTableAnnotationComposer a) f) {
    final $$NutritionLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.nutritionLogs,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NutritionLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.nutritionLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EncountersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EncountersTable,
    Encounter,
    $$EncountersTableFilterComposer,
    $$EncountersTableOrderingComposer,
    $$EncountersTableAnnotationComposer,
    $$EncountersTableCreateCompanionBuilder,
    $$EncountersTableUpdateCompanionBuilder,
    (Encounter, $$EncountersTableReferences),
    Encounter,
    PrefetchHooks Function(
        {bool patientUuid,
        bool maternalCareDetailsRefs,
        bool immunizationDetailsRefs,
        bool nutritionLogsRefs})> {
  $$EncountersTableTableManager(_$AppDatabase db, $EncountersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EncountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EncountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EncountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> encounterUuid = const Value.absent(),
            Value<String> patientUuid = const Value.absent(),
            Value<String> bhwUserId = const Value.absent(),
            Value<String> encounterType = const Value.absent(),
            Value<String> encounterTimestamp = const Value.absent(),
            Value<String> triageRiskLevel = const Value.absent(),
            Value<String?> clinicalNotes = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EncountersCompanion(
            encounterUuid: encounterUuid,
            patientUuid: patientUuid,
            bhwUserId: bhwUserId,
            encounterType: encounterType,
            encounterTimestamp: encounterTimestamp,
            triageRiskLevel: triageRiskLevel,
            clinicalNotes: clinicalNotes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String encounterUuid,
            required String patientUuid,
            required String bhwUserId,
            required String encounterType,
            required String encounterTimestamp,
            required String triageRiskLevel,
            Value<String?> clinicalNotes = const Value.absent(),
            required String createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EncountersCompanion.insert(
            encounterUuid: encounterUuid,
            patientUuid: patientUuid,
            bhwUserId: bhwUserId,
            encounterType: encounterType,
            encounterTimestamp: encounterTimestamp,
            triageRiskLevel: triageRiskLevel,
            clinicalNotes: clinicalNotes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$EncountersTable, Encounter>(table),
                    $$EncountersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {patientUuid = false,
              maternalCareDetailsRefs = false,
              immunizationDetailsRefs = false,
              nutritionLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (maternalCareDetailsRefs) db.maternalCareDetails,
                if (immunizationDetailsRefs) db.immunizationDetails,
                if (nutritionLogsRefs) db.nutritionLogs
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (patientUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.patientUuid,
                    referencedTable:
                        $$EncountersTableReferences._patientUuidTable(db),
                    referencedColumn: $$EncountersTableReferences
                        ._patientUuidTable(db)
                        .patientUuid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (maternalCareDetailsRefs)
                    await $_getPrefetchedData<Encounter, $EncountersTable,
                            MaternalCareDetail>(
                        currentTable: table,
                        referencedTable: $$EncountersTableReferences
                            ._maternalCareDetailsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EncountersTableReferences(db, table, p0)
                                .maternalCareDetailsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.encounterUuid == item.encounterUuid),
                        typedResults: items),
                  if (immunizationDetailsRefs)
                    await $_getPrefetchedData<Encounter, $EncountersTable,
                            ImmunizationDetail>(
                        currentTable: table,
                        referencedTable: $$EncountersTableReferences
                            ._immunizationDetailsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EncountersTableReferences(db, table, p0)
                                .immunizationDetailsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.encounterUuid == item.encounterUuid),
                        typedResults: items),
                  if (nutritionLogsRefs)
                    await $_getPrefetchedData<Encounter, $EncountersTable,
                            NutritionLog>(
                        currentTable: table,
                        referencedTable: $$EncountersTableReferences
                            ._nutritionLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EncountersTableReferences(db, table, p0)
                                .nutritionLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems.where(
                                (e) => e.encounterUuid == item.encounterUuid),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EncountersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EncountersTable,
    Encounter,
    $$EncountersTableFilterComposer,
    $$EncountersTableOrderingComposer,
    $$EncountersTableAnnotationComposer,
    $$EncountersTableCreateCompanionBuilder,
    $$EncountersTableUpdateCompanionBuilder,
    (Encounter, $$EncountersTableReferences),
    Encounter,
    PrefetchHooks Function(
        {bool patientUuid,
        bool maternalCareDetailsRefs,
        bool immunizationDetailsRefs,
        bool nutritionLogsRefs})>;
typedef $$MaternalCareDetailsTableCreateCompanionBuilder
    = MaternalCareDetailsCompanion Function({
  required String encounterUuid,
  required String lmpDate,
  required String edcDate,
  required int gravidity,
  required int parity,
  required int systolicBp,
  required int diastolicBp,
  required double maternalWeightKg,
  Value<double?> fundicHeightCm,
  required int ironFolicGiven,
  Value<int> rowid,
});
typedef $$MaternalCareDetailsTableUpdateCompanionBuilder
    = MaternalCareDetailsCompanion Function({
  Value<String> encounterUuid,
  Value<String> lmpDate,
  Value<String> edcDate,
  Value<int> gravidity,
  Value<int> parity,
  Value<int> systolicBp,
  Value<int> diastolicBp,
  Value<double> maternalWeightKg,
  Value<double?> fundicHeightCm,
  Value<int> ironFolicGiven,
  Value<int> rowid,
});

final class $$MaternalCareDetailsTableReferences extends BaseReferences<
    _$AppDatabase, $MaternalCareDetailsTable, MaternalCareDetail> {
  $$MaternalCareDetailsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EncountersTable _encounterUuidTable(_$AppDatabase db) =>
      db.encounters.createAlias(
          'maternal_care_details__encounter_uuid__encounters__encounter_uuid');

  $$EncountersTableProcessedTableManager get encounterUuid {
    final $_column = $_itemColumn<String>('encounter_uuid')!;

    final manager = $$EncountersTableTableManager($_db, $_db.encounters)
        .filter((f) => f.encounterUuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_encounterUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MaternalCareDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $MaternalCareDetailsTable> {
  $$MaternalCareDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lmpDate => $composableBuilder(
      column: $table.lmpDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get edcDate => $composableBuilder(
      column: $table.edcDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gravidity => $composableBuilder(
      column: $table.gravidity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parity => $composableBuilder(
      column: $table.parity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get systolicBp => $composableBuilder(
      column: $table.systolicBp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get diastolicBp => $composableBuilder(
      column: $table.diastolicBp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maternalWeightKg => $composableBuilder(
      column: $table.maternalWeightKg,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fundicHeightCm => $composableBuilder(
      column: $table.fundicHeightCm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ironFolicGiven => $composableBuilder(
      column: $table.ironFolicGiven,
      builder: (column) => ColumnFilters(column));

  $$EncountersTableFilterComposer get encounterUuid {
    final $$EncountersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableFilterComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaternalCareDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $MaternalCareDetailsTable> {
  $$MaternalCareDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lmpDate => $composableBuilder(
      column: $table.lmpDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get edcDate => $composableBuilder(
      column: $table.edcDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gravidity => $composableBuilder(
      column: $table.gravidity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parity => $composableBuilder(
      column: $table.parity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get systolicBp => $composableBuilder(
      column: $table.systolicBp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get diastolicBp => $composableBuilder(
      column: $table.diastolicBp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maternalWeightKg => $composableBuilder(
      column: $table.maternalWeightKg,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fundicHeightCm => $composableBuilder(
      column: $table.fundicHeightCm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ironFolicGiven => $composableBuilder(
      column: $table.ironFolicGiven,
      builder: (column) => ColumnOrderings(column));

  $$EncountersTableOrderingComposer get encounterUuid {
    final $$EncountersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableOrderingComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaternalCareDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MaternalCareDetailsTable> {
  $$MaternalCareDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lmpDate =>
      $composableBuilder(column: $table.lmpDate, builder: (column) => column);

  GeneratedColumn<String> get edcDate =>
      $composableBuilder(column: $table.edcDate, builder: (column) => column);

  GeneratedColumn<int> get gravidity =>
      $composableBuilder(column: $table.gravidity, builder: (column) => column);

  GeneratedColumn<int> get parity =>
      $composableBuilder(column: $table.parity, builder: (column) => column);

  GeneratedColumn<int> get systolicBp => $composableBuilder(
      column: $table.systolicBp, builder: (column) => column);

  GeneratedColumn<int> get diastolicBp => $composableBuilder(
      column: $table.diastolicBp, builder: (column) => column);

  GeneratedColumn<double> get maternalWeightKg => $composableBuilder(
      column: $table.maternalWeightKg, builder: (column) => column);

  GeneratedColumn<double> get fundicHeightCm => $composableBuilder(
      column: $table.fundicHeightCm, builder: (column) => column);

  GeneratedColumn<int> get ironFolicGiven => $composableBuilder(
      column: $table.ironFolicGiven, builder: (column) => column);

  $$EncountersTableAnnotationComposer get encounterUuid {
    final $$EncountersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableAnnotationComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MaternalCareDetailsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MaternalCareDetailsTable,
    MaternalCareDetail,
    $$MaternalCareDetailsTableFilterComposer,
    $$MaternalCareDetailsTableOrderingComposer,
    $$MaternalCareDetailsTableAnnotationComposer,
    $$MaternalCareDetailsTableCreateCompanionBuilder,
    $$MaternalCareDetailsTableUpdateCompanionBuilder,
    (MaternalCareDetail, $$MaternalCareDetailsTableReferences),
    MaternalCareDetail,
    PrefetchHooks Function({bool encounterUuid})> {
  $$MaternalCareDetailsTableTableManager(
      _$AppDatabase db, $MaternalCareDetailsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaternalCareDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MaternalCareDetailsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MaternalCareDetailsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> encounterUuid = const Value.absent(),
            Value<String> lmpDate = const Value.absent(),
            Value<String> edcDate = const Value.absent(),
            Value<int> gravidity = const Value.absent(),
            Value<int> parity = const Value.absent(),
            Value<int> systolicBp = const Value.absent(),
            Value<int> diastolicBp = const Value.absent(),
            Value<double> maternalWeightKg = const Value.absent(),
            Value<double?> fundicHeightCm = const Value.absent(),
            Value<int> ironFolicGiven = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MaternalCareDetailsCompanion(
            encounterUuid: encounterUuid,
            lmpDate: lmpDate,
            edcDate: edcDate,
            gravidity: gravidity,
            parity: parity,
            systolicBp: systolicBp,
            diastolicBp: diastolicBp,
            maternalWeightKg: maternalWeightKg,
            fundicHeightCm: fundicHeightCm,
            ironFolicGiven: ironFolicGiven,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String encounterUuid,
            required String lmpDate,
            required String edcDate,
            required int gravidity,
            required int parity,
            required int systolicBp,
            required int diastolicBp,
            required double maternalWeightKg,
            Value<double?> fundicHeightCm = const Value.absent(),
            required int ironFolicGiven,
            Value<int> rowid = const Value.absent(),
          }) =>
              MaternalCareDetailsCompanion.insert(
            encounterUuid: encounterUuid,
            lmpDate: lmpDate,
            edcDate: edcDate,
            gravidity: gravidity,
            parity: parity,
            systolicBp: systolicBp,
            diastolicBp: diastolicBp,
            maternalWeightKg: maternalWeightKg,
            fundicHeightCm: fundicHeightCm,
            ironFolicGiven: ironFolicGiven,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MaternalCareDetailsTable, MaternalCareDetail>(
                        table),
                    $$MaternalCareDetailsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({encounterUuid = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (encounterUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.encounterUuid,
                    referencedTable: $$MaternalCareDetailsTableReferences
                        ._encounterUuidTable(db),
                    referencedColumn: $$MaternalCareDetailsTableReferences
                        ._encounterUuidTable(db)
                        .encounterUuid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MaternalCareDetailsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MaternalCareDetailsTable,
    MaternalCareDetail,
    $$MaternalCareDetailsTableFilterComposer,
    $$MaternalCareDetailsTableOrderingComposer,
    $$MaternalCareDetailsTableAnnotationComposer,
    $$MaternalCareDetailsTableCreateCompanionBuilder,
    $$MaternalCareDetailsTableUpdateCompanionBuilder,
    (MaternalCareDetail, $$MaternalCareDetailsTableReferences),
    MaternalCareDetail,
    PrefetchHooks Function({bool encounterUuid})>;
typedef $$ImmunizationDetailsTableCreateCompanionBuilder
    = ImmunizationDetailsCompanion Function({
  required String encounterUuid,
  required String antigenCode,
  required int doseNumber,
  required String administrationDate,
  Value<String?> lotNumber,
  Value<int> rowid,
});
typedef $$ImmunizationDetailsTableUpdateCompanionBuilder
    = ImmunizationDetailsCompanion Function({
  Value<String> encounterUuid,
  Value<String> antigenCode,
  Value<int> doseNumber,
  Value<String> administrationDate,
  Value<String?> lotNumber,
  Value<int> rowid,
});

final class $$ImmunizationDetailsTableReferences extends BaseReferences<
    _$AppDatabase, $ImmunizationDetailsTable, ImmunizationDetail> {
  $$ImmunizationDetailsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EncountersTable _encounterUuidTable(_$AppDatabase db) =>
      db.encounters.createAlias(
          'immunization_details__encounter_uuid__encounters__encounter_uuid');

  $$EncountersTableProcessedTableManager get encounterUuid {
    final $_column = $_itemColumn<String>('encounter_uuid')!;

    final manager = $$EncountersTableTableManager($_db, $_db.encounters)
        .filter((f) => f.encounterUuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_encounterUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ImmunizationDetailsTableFilterComposer
    extends Composer<_$AppDatabase, $ImmunizationDetailsTable> {
  $$ImmunizationDetailsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get antigenCode => $composableBuilder(
      column: $table.antigenCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get administrationDate => $composableBuilder(
      column: $table.administrationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lotNumber => $composableBuilder(
      column: $table.lotNumber, builder: (column) => ColumnFilters(column));

  $$EncountersTableFilterComposer get encounterUuid {
    final $$EncountersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableFilterComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ImmunizationDetailsTableOrderingComposer
    extends Composer<_$AppDatabase, $ImmunizationDetailsTable> {
  $$ImmunizationDetailsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get antigenCode => $composableBuilder(
      column: $table.antigenCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get administrationDate => $composableBuilder(
      column: $table.administrationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lotNumber => $composableBuilder(
      column: $table.lotNumber, builder: (column) => ColumnOrderings(column));

  $$EncountersTableOrderingComposer get encounterUuid {
    final $$EncountersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableOrderingComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ImmunizationDetailsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ImmunizationDetailsTable> {
  $$ImmunizationDetailsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get antigenCode => $composableBuilder(
      column: $table.antigenCode, builder: (column) => column);

  GeneratedColumn<int> get doseNumber => $composableBuilder(
      column: $table.doseNumber, builder: (column) => column);

  GeneratedColumn<String> get administrationDate => $composableBuilder(
      column: $table.administrationDate, builder: (column) => column);

  GeneratedColumn<String> get lotNumber =>
      $composableBuilder(column: $table.lotNumber, builder: (column) => column);

  $$EncountersTableAnnotationComposer get encounterUuid {
    final $$EncountersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableAnnotationComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ImmunizationDetailsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ImmunizationDetailsTable,
    ImmunizationDetail,
    $$ImmunizationDetailsTableFilterComposer,
    $$ImmunizationDetailsTableOrderingComposer,
    $$ImmunizationDetailsTableAnnotationComposer,
    $$ImmunizationDetailsTableCreateCompanionBuilder,
    $$ImmunizationDetailsTableUpdateCompanionBuilder,
    (ImmunizationDetail, $$ImmunizationDetailsTableReferences),
    ImmunizationDetail,
    PrefetchHooks Function({bool encounterUuid})> {
  $$ImmunizationDetailsTableTableManager(
      _$AppDatabase db, $ImmunizationDetailsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ImmunizationDetailsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ImmunizationDetailsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ImmunizationDetailsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> encounterUuid = const Value.absent(),
            Value<String> antigenCode = const Value.absent(),
            Value<int> doseNumber = const Value.absent(),
            Value<String> administrationDate = const Value.absent(),
            Value<String?> lotNumber = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ImmunizationDetailsCompanion(
            encounterUuid: encounterUuid,
            antigenCode: antigenCode,
            doseNumber: doseNumber,
            administrationDate: administrationDate,
            lotNumber: lotNumber,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String encounterUuid,
            required String antigenCode,
            required int doseNumber,
            required String administrationDate,
            Value<String?> lotNumber = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ImmunizationDetailsCompanion.insert(
            encounterUuid: encounterUuid,
            antigenCode: antigenCode,
            doseNumber: doseNumber,
            administrationDate: administrationDate,
            lotNumber: lotNumber,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ImmunizationDetailsTable, ImmunizationDetail>(
                        table),
                    $$ImmunizationDetailsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({encounterUuid = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (encounterUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.encounterUuid,
                    referencedTable: $$ImmunizationDetailsTableReferences
                        ._encounterUuidTable(db),
                    referencedColumn: $$ImmunizationDetailsTableReferences
                        ._encounterUuidTable(db)
                        .encounterUuid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ImmunizationDetailsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ImmunizationDetailsTable,
    ImmunizationDetail,
    $$ImmunizationDetailsTableFilterComposer,
    $$ImmunizationDetailsTableOrderingComposer,
    $$ImmunizationDetailsTableAnnotationComposer,
    $$ImmunizationDetailsTableCreateCompanionBuilder,
    $$ImmunizationDetailsTableUpdateCompanionBuilder,
    (ImmunizationDetail, $$ImmunizationDetailsTableReferences),
    ImmunizationDetail,
    PrefetchHooks Function({bool encounterUuid})>;
typedef $$NutritionLogsTableCreateCompanionBuilder = NutritionLogsCompanion
    Function({
  required String encounterUuid,
  required int ageMonths,
  required double weightKg,
  required double heightCm,
  required String posture,
  required int edema,
  required double whzScore,
  required double hazScore,
  required double wazScore,
  required String nutritionalStatus,
  Value<int> rowid,
});
typedef $$NutritionLogsTableUpdateCompanionBuilder = NutritionLogsCompanion
    Function({
  Value<String> encounterUuid,
  Value<int> ageMonths,
  Value<double> weightKg,
  Value<double> heightCm,
  Value<String> posture,
  Value<int> edema,
  Value<double> whzScore,
  Value<double> hazScore,
  Value<double> wazScore,
  Value<String> nutritionalStatus,
  Value<int> rowid,
});

final class $$NutritionLogsTableReferences
    extends BaseReferences<_$AppDatabase, $NutritionLogsTable, NutritionLog> {
  $$NutritionLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EncountersTable _encounterUuidTable(_$AppDatabase db) =>
      db.encounters.createAlias(
          'nutrition_logs__encounter_uuid__encounters__encounter_uuid');

  $$EncountersTableProcessedTableManager get encounterUuid {
    final $_column = $_itemColumn<String>('encounter_uuid')!;

    final manager = $$EncountersTableTableManager($_db, $_db.encounters)
        .filter((f) => f.encounterUuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_encounterUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NutritionLogsTableFilterComposer
    extends Composer<_$AppDatabase, $NutritionLogsTable> {
  $$NutritionLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ageMonths => $composableBuilder(
      column: $table.ageMonths, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get posture => $composableBuilder(
      column: $table.posture, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get edema => $composableBuilder(
      column: $table.edema, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get whzScore => $composableBuilder(
      column: $table.whzScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hazScore => $composableBuilder(
      column: $table.hazScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get wazScore => $composableBuilder(
      column: $table.wazScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nutritionalStatus => $composableBuilder(
      column: $table.nutritionalStatus,
      builder: (column) => ColumnFilters(column));

  $$EncountersTableFilterComposer get encounterUuid {
    final $$EncountersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableFilterComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $NutritionLogsTable> {
  $$NutritionLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ageMonths => $composableBuilder(
      column: $table.ageMonths, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get heightCm => $composableBuilder(
      column: $table.heightCm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get posture => $composableBuilder(
      column: $table.posture, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get edema => $composableBuilder(
      column: $table.edema, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get whzScore => $composableBuilder(
      column: $table.whzScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hazScore => $composableBuilder(
      column: $table.hazScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get wazScore => $composableBuilder(
      column: $table.wazScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nutritionalStatus => $composableBuilder(
      column: $table.nutritionalStatus,
      builder: (column) => ColumnOrderings(column));

  $$EncountersTableOrderingComposer get encounterUuid {
    final $$EncountersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableOrderingComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutritionLogsTable> {
  $$NutritionLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ageMonths =>
      $composableBuilder(column: $table.ageMonths, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<String> get posture =>
      $composableBuilder(column: $table.posture, builder: (column) => column);

  GeneratedColumn<int> get edema =>
      $composableBuilder(column: $table.edema, builder: (column) => column);

  GeneratedColumn<double> get whzScore =>
      $composableBuilder(column: $table.whzScore, builder: (column) => column);

  GeneratedColumn<double> get hazScore =>
      $composableBuilder(column: $table.hazScore, builder: (column) => column);

  GeneratedColumn<double> get wazScore =>
      $composableBuilder(column: $table.wazScore, builder: (column) => column);

  GeneratedColumn<String> get nutritionalStatus => $composableBuilder(
      column: $table.nutritionalStatus, builder: (column) => column);

  $$EncountersTableAnnotationComposer get encounterUuid {
    final $$EncountersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.encounterUuid,
        referencedTable: $db.encounters,
        getReferencedColumn: (t) => t.encounterUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EncountersTableAnnotationComposer(
              $db: $db,
              $table: $db.encounters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NutritionLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NutritionLogsTable,
    NutritionLog,
    $$NutritionLogsTableFilterComposer,
    $$NutritionLogsTableOrderingComposer,
    $$NutritionLogsTableAnnotationComposer,
    $$NutritionLogsTableCreateCompanionBuilder,
    $$NutritionLogsTableUpdateCompanionBuilder,
    (NutritionLog, $$NutritionLogsTableReferences),
    NutritionLog,
    PrefetchHooks Function({bool encounterUuid})> {
  $$NutritionLogsTableTableManager(_$AppDatabase db, $NutritionLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutritionLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutritionLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutritionLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> encounterUuid = const Value.absent(),
            Value<int> ageMonths = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<double> heightCm = const Value.absent(),
            Value<String> posture = const Value.absent(),
            Value<int> edema = const Value.absent(),
            Value<double> whzScore = const Value.absent(),
            Value<double> hazScore = const Value.absent(),
            Value<double> wazScore = const Value.absent(),
            Value<String> nutritionalStatus = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NutritionLogsCompanion(
            encounterUuid: encounterUuid,
            ageMonths: ageMonths,
            weightKg: weightKg,
            heightCm: heightCm,
            posture: posture,
            edema: edema,
            whzScore: whzScore,
            hazScore: hazScore,
            wazScore: wazScore,
            nutritionalStatus: nutritionalStatus,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String encounterUuid,
            required int ageMonths,
            required double weightKg,
            required double heightCm,
            required String posture,
            required int edema,
            required double whzScore,
            required double hazScore,
            required double wazScore,
            required String nutritionalStatus,
            Value<int> rowid = const Value.absent(),
          }) =>
              NutritionLogsCompanion.insert(
            encounterUuid: encounterUuid,
            ageMonths: ageMonths,
            weightKg: weightKg,
            heightCm: heightCm,
            posture: posture,
            edema: edema,
            whzScore: whzScore,
            hazScore: hazScore,
            wazScore: wazScore,
            nutritionalStatus: nutritionalStatus,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$NutritionLogsTable, NutritionLog>(table),
                    $$NutritionLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({encounterUuid = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (encounterUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.encounterUuid,
                    referencedTable:
                        $$NutritionLogsTableReferences._encounterUuidTable(db),
                    referencedColumn: $$NutritionLogsTableReferences
                        ._encounterUuidTable(db)
                        .encounterUuid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NutritionLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NutritionLogsTable,
    NutritionLog,
    $$NutritionLogsTableFilterComposer,
    $$NutritionLogsTableOrderingComposer,
    $$NutritionLogsTableAnnotationComposer,
    $$NutritionLogsTableCreateCompanionBuilder,
    $$NutritionLogsTableUpdateCompanionBuilder,
    (NutritionLog, $$NutritionLogsTableReferences),
    NutritionLog,
    PrefetchHooks Function({bool encounterUuid})>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> queueId,
  required String entityUuid,
  required String entityType,
  required String operationType,
  required String payloadJson,
  required String syncStatus,
  Value<int> retryCount,
  required String createdAt,
  Value<String?> syncedAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> queueId,
  Value<String> entityUuid,
  Value<String> entityType,
  Value<String> operationType,
  Value<String> payloadJson,
  Value<String> syncStatus,
  Value<int> retryCount,
  Value<String> createdAt,
  Value<String?> syncedAt,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get queueId => $composableBuilder(
      column: $table.queueId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityUuid => $composableBuilder(
      column: $table.entityUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get queueId => $composableBuilder(
      column: $table.queueId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityUuid => $composableBuilder(
      column: $table.entityUuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operationType => $composableBuilder(
      column: $table.operationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get queueId =>
      $composableBuilder(column: $table.queueId, builder: (column) => column);

  GeneratedColumn<String> get entityUuid => $composableBuilder(
      column: $table.entityUuid, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> queueId = const Value.absent(),
            Value<String> entityUuid = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> operationType = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String?> syncedAt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            queueId: queueId,
            entityUuid: entityUuid,
            entityType: entityType,
            operationType: operationType,
            payloadJson: payloadJson,
            syncStatus: syncStatus,
            retryCount: retryCount,
            createdAt: createdAt,
            syncedAt: syncedAt,
          ),
          createCompanionCallback: ({
            Value<int> queueId = const Value.absent(),
            required String entityUuid,
            required String entityType,
            required String operationType,
            required String payloadJson,
            required String syncStatus,
            Value<int> retryCount = const Value.absent(),
            required String createdAt,
            Value<String?> syncedAt = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            queueId: queueId,
            entityUuid: entityUuid,
            entityType: entityType,
            operationType: operationType,
            payloadJson: payloadJson,
            syncStatus: syncStatus,
            retryCount: retryCount,
            createdAt: createdAt,
            syncedAt: syncedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$SyncQueueTable, SyncQueueData>(table),
                    BaseReferences<_$AppDatabase, $SyncQueueTable,
                        SyncQueueData>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HouseholdsTableTableManager get households =>
      $$HouseholdsTableTableManager(_db, _db.households);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$EncountersTableTableManager get encounters =>
      $$EncountersTableTableManager(_db, _db.encounters);
  $$MaternalCareDetailsTableTableManager get maternalCareDetails =>
      $$MaternalCareDetailsTableTableManager(_db, _db.maternalCareDetails);
  $$ImmunizationDetailsTableTableManager get immunizationDetails =>
      $$ImmunizationDetailsTableTableManager(_db, _db.immunizationDetails);
  $$NutritionLogsTableTableManager get nutritionLogs =>
      $$NutritionLogsTableTableManager(_db, _db.nutritionLogs);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
