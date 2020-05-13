import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_stats/stats_simple_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/details/details_tutor_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/identity/identity_tutors_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/requirements/requirements_tutor_entity.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';

class TutorProfileEntity extends TutorProfile
    implements EntityBase<TutorProfile> {
  const TutorProfileEntity({
    DetailsTutorEntity detailsTutor,
    IdentityTutorEntity identityTutor,
    RequirementsTutorEntity requirementsTutor,
    StatsSimpleEntity statsSimple,
  })  : _detailsTutor = detailsTutor,
        _identityTutor = identityTutor,
        _requirementsTutor = requirementsTutor,
        _statsSimple = statsSimple,
        super(
          detailsTutor: detailsTutor,
          identityTutor: identityTutor,
          requirementsTutor: requirementsTutor,
          statsSimple: statsSimple,
        );

  factory TutorProfileEntity.fromDocumentSnapshot(
      Map<String, dynamic> json, String uid) {
    if (json == null || json.isEmpty) {
      return null;
    }
    json[IDENTITY][UID] = uid;
    return TutorProfileEntity(
      identityTutor: IdentityTutorEntity.fromJson(json[IDENTITY]),
      detailsTutor: DetailsTutorEntity.fromFirebaseMap(json[DETAILS]),
      requirementsTutor:
          RequirementsTutorEntity.fromFirebaseMap(json[REQUIREMENTS]),
      statsSimple: StatsSimpleEntity.fromJson(json[STATS_SIMPLE]),
    );
  }

  factory TutorProfileEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return TutorProfileEntity(
      identityTutor: IdentityTutorEntity.fromJson(json[IDENTITY]),
      detailsTutor: DetailsTutorEntity.fromJson(json[DETAILS]),
      requirementsTutor: RequirementsTutorEntity.fromJson(json[REQUIREMENTS]),
      statsSimple: StatsSimpleEntity.fromJson(json[STATS_SIMPLE]),
    );
  }

  factory TutorProfileEntity.fromDomainEntity(TutorProfile entity) {
    return TutorProfileEntity(
      identityTutor: IdentityTutorEntity.fromDomainEntity(entity.identity),
      detailsTutor: DetailsTutorEntity.fromDomainEntity(entity.details),
      requirementsTutor:
          RequirementsTutorEntity.fromDomainEntity(entity.requirements),
      statsSimple: StatsSimpleEntity.fromDomainEntity(entity.stats),
    );
  }
  final DetailsTutorEntity _detailsTutor;
  final IdentityTutorEntity _identityTutor;
  final RequirementsTutorEntity _requirementsTutor;
  final StatsSimpleEntity _statsSimple;

  @override
  DetailsTutorEntity get details => _detailsTutor;

  @override
  IdentityTutorEntity get identity => _identityTutor;

  @override
  RequirementsTutorEntity get requirements => _requirementsTutor;

  @override
  StatsSimpleEntity get stats => _statsSimple;

  @override
  TutorProfile toDomainEntity() {
    return TutorProfile(
      identityTutor: identity.toDomainEntity(),
      detailsTutor: details.toDomainEntity(),
      requirementsTutor: requirements.toDomainEntity(),
      statsSimple: stats.toDomainEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      IDENTITY: identity.toJson(),
      DETAILS: details.toJson(),
      REQUIREMENTS: requirements.toJson(),
      STATS_SIMPLE: stats.toJson()
    };
  }

  Map<String, dynamic> toDoucmentSnapshot({bool isNew}) {
    return <String, dynamic>{
      IDENTITY: identity.toFirebaseMap(),
      DETAILS: details.toFirebaseMap(isNew: isNew),
      REQUIREMENTS: requirements.toFirebaseMap(),
      STATS_SIMPLE: stats.toFirebaseMap(isNew: isNew),
    };
  }

  @override
  List<Object> get props => [
        _detailsTutor,
        _requirementsTutor,
        _identityTutor,
        _statsSimple,
      ];

  @override
  String toString() => '''TutorProfileEntity(
        detailsTutor: $details, 
        identityTutor: $identity, 
        requirementsTutor: $requirements,
        stats: $stats
      )''';

  Map<String, dynamic> toNewDocumentSnapshot() {}

  Map<String, dynamic> toExistingDocumentSnapshot(Map<String, dynamic> data) {}
}
