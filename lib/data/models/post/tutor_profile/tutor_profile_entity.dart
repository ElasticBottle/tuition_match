import 'package:cotor/data/models/post/post_base._entity.dart';
import 'package:cotor/domain/entities/post/base_post/post_base.dart';
import 'package:meta/meta.dart';

import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_stats/stats_simple_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/details/details_tutor_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/identity/identity_tutors_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/requirements/requirements_tutor_entity.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';

class TutorProfileEntity extends TutorProfile
    implements PostBaseEntity<TutorProfile> {
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

  factory TutorProfileEntity.fromDocumentSnapshot(Map<String, dynamic> json,
      {String uid = '', bool needId = true}) {
    if (json == null || json.isEmpty) {
      return null;
    }
    if (needId) {
      json[IDENTITY][UID] = uid;
    }
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

  factory TutorProfileEntity.fromDomainEntity(PostBase entity) {
    return TutorProfileEntity(
      identityTutor: IdentityTutorEntity.fromDomainEntity(entity.identity),
      detailsTutor: DetailsTutorEntity.fromDomainEntity(entity.details),
      requirementsTutor:
          RequirementsTutorEntity.fromDomainEntity(entity.requirements),
      statsSimple: entity.stats != null
          ? StatsSimpleEntity.fromDomainEntity(entity.stats)
          : null,
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
  bool get isAssignment => false;
  @override
  bool get isProfile => true;

  @override
  TutorProfile toDomainEntity() {
    return TutorProfile(
      identityTutor: identity.toDomainEntity(),
      detailsTutor: details.toDomainEntity(),
      requirementsTutor: requirements.toDomainEntity(),
      statsSimple: stats?.toDomainEntity(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      IDENTITY: identity.toJson(),
      DETAILS: details.toJson(),
      REQUIREMENTS: requirements.toJson(),
      STATS_SIMPLE: stats.toJson()
    };
  }

  @override
  Map<String, dynamic> toDocumentSnapshot(
      {@required bool isNew, bool freeze = false}) {
    return <String, dynamic>{
      IDENTITY: identity.toFirebaseMap(),
      DETAILS: details.toFirebaseMap(isNew: isNew, freeze: freeze),
      REQUIREMENTS: requirements.toFirebaseMap(),
      STATS_SIMPLE: stats.toFirebaseMap(isNew: isNew),
    };
  }

  @override
  Map<String, dynamic> toApplicationJson() {
    return <String, dynamic>{
      IDENTITY: identity.toJson(),
      DETAILS: details.toJson(),
      REQUIREMENTS: requirements.toJson(),
    };
  }

  @override
  Map<String, dynamic> toApplicationMap(
      {@required bool isNew, @required bool freeze}) {
    return <String, dynamic>{
      IDENTITY: identity.toJson(),
      DETAILS: details.toFirebaseMap(isNew: isNew, freeze: freeze),
      REQUIREMENTS: requirements.toFirebaseMap(),
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
