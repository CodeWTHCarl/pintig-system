class SyncPayloadEnvelopeDto {
  final String syncBatchId;
  final String deviceId;
  final String tenantId;
  final String barangayId;
  final String clientVersion;
  final String dispatchedAt;
  final int payloadCount;
  final List<DemographicMutationDto> demographicMutations;
  final List<ClinicalEncounterDto> clinicalEncounters;

  const SyncPayloadEnvelopeDto({
    required this.syncBatchId,
    required this.deviceId,
    required this.tenantId,
    required this.barangayId,
    required this.clientVersion,
    required this.dispatchedAt,
    required this.payloadCount,
    required this.demographicMutations,
    required this.clinicalEncounters,
  });

  factory SyncPayloadEnvelopeDto.fromJson(Map<String, dynamic> json) {
    return SyncPayloadEnvelopeDto(
      syncBatchId: json['sync_batch_id'] as String,
      deviceId: json['device_id'] as String,
      tenantId: json['tenant_id'] as String,
      barangayId: json['barangay_id'] as String,
      clientVersion: json['client_version'] as String,
      dispatchedAt: json['dispatched_at'] as String,
      payloadCount: json['payload_count'] as int,
      demographicMutations: (json['demographic_mutations'] as List<dynamic>?)
              ?.map((e) => DemographicMutationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      clinicalEncounters: (json['clinical_encounters'] as List<dynamic>?)
              ?.map((e) => ClinicalEncounterDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'sync_batch_id': syncBatchId,
        'device_id': deviceId,
        'tenant_id': tenantId,
        'barangay_id': barangayId,
        'client_version': clientVersion,
        'dispatched_at': dispatchedAt,
        'payload_count': payloadCount,
        'demographic_mutations': demographicMutations.map((e) => e.toJson()).toList(),
        'clinical_encounters': clinicalEncounters.map((e) => e.toJson()).toList(),
      };
}

class DemographicMutationDto {
  final String entityType; // HOUSEHOLD | PATIENT
  final String entityUuid;
  final String mutationTimestamp;
  final Map<String, FieldPayloadDto> fields;

  const DemographicMutationDto({
    required this.entityType,
    required this.entityUuid,
    required this.mutationTimestamp,
    required this.fields,
  });

  factory DemographicMutationDto.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'] as Map<String, dynamic>;
    final parsedFields = rawFields.map(
      (key, value) => MapEntry(key, FieldPayloadDto.fromJson(value as Map<String, dynamic>)),
    );
    return DemographicMutationDto(
      entityType: json['entity_type'] as String,
      entityUuid: json['entity_uuid'] as String,
      mutationTimestamp: json['mutation_timestamp'] as String,
      fields: parsedFields,
    );
  }

  Map<String, dynamic> toJson() => {
        'entity_type': entityType,
        'entity_uuid': entityUuid,
        'mutation_timestamp': mutationTimestamp,
        'fields': fields.map((key, value) => MapEntry(key, value.toJson())),
      };
}

class FieldPayloadDto {
  final dynamic value;
  final String updatedAt;

  const FieldPayloadDto({required this.value, required this.updatedAt});

  factory FieldPayloadDto.fromJson(Map<String, dynamic> json) {
    return FieldPayloadDto(
      value: json['value'],
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'updated_at': updatedAt,
      };
}

class ClinicalEncounterDto {
  final String encounterUuid;
  final String patientUuid;
  final String bhwId;
  final String encounterType; // MATERNAL_CARE | IMMUNIZATION | NUTRITION_OPT
  final String timestamp;
  final String triageRiskLevel; // NORMAL | MODERATE | HIGH
  final Map<String, dynamic> clinicalData;

  const ClinicalEncounterDto({
    required this.encounterUuid,
    required this.patientUuid,
    required this.bhwId,
    required this.encounterType,
    required this.timestamp,
    required this.triageRiskLevel,
    required this.clinicalData,
  });

  factory ClinicalEncounterDto.fromJson(Map<String, dynamic> json) {
    return ClinicalEncounterDto(
      encounterUuid: json['encounter_uuid'] as String,
      patientUuid: json['patient_uuid'] as String,
      bhwId: json['bhw_id'] as String,
      encounterType: json['encounter_type'] as String,
      timestamp: json['timestamp'] as String,
      triageRiskLevel: json['triage_risk_level'] as String,
      clinicalData: json['clinical_data'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => {
        'encounter_uuid': encounterUuid,
        'patient_uuid': patientUuid,
        'bhw_id': bhwId,
        'encounter_type': encounterType,
        'timestamp': timestamp,
        'triage_risk_level': triageRiskLevel,
        'clinical_data': clinicalData,
      };
}