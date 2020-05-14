import 'package:meta/meta.dart';

import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_stats/stats_simple_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/details/detail_tutee_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/indentity/identity_tutee_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/requirements/requirements_tutee_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';

class TuteeAssignmentEntity extends TuteeAssignment
    implements EntityBase<TuteeAssignment> {
  const TuteeAssignmentEntity({
    DetailsTuteeEntity detailsTutee,
    IdentityTuteeEntity identityTutee,
    RequirementsTuteeEntity requirementsTutee,
    StatsSimpleEntity statsSimple,
  })  : _detailsTutee = detailsTutee,
        _identityTutee = identityTutee,
        _requirementsTutee = requirementsTutee,
        _statsSimple = statsSimple,
        super(
          detailsTutee: detailsTutee,
          identityTutee: identityTutee,
          requirementsTutee: requirementsTutee,
          statsSimple: statsSimple,
        );

  factory TuteeAssignmentEntity.fromDocumentSnapshot(
      Map<String, dynamic> json, String postId) {
    if (json == null || json.isEmpty) {
      return null;
    }
    json[IDENTITY][POST_ID] = postId;
    return TuteeAssignmentEntity(
      identityTutee: IdentityTuteeEntity.fromJson(json[IDENTITY]),
      detailsTutee: DetailsTuteeEntity.fromFirebaseMap(json[DETAILS]),
      requirementsTutee:
          RequirementsTuteeEntity.fromFirebaseMap(json[REQUIREMENTS]),
      statsSimple: StatsSimpleEntity.fromJson(json[STATS_SIMPLE]),
    );
  }

  factory TuteeAssignmentEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return TuteeAssignmentEntity(
      identityTutee: IdentityTuteeEntity.fromJson(json[IDENTITY]),
      detailsTutee: DetailsTuteeEntity.fromJson(json[DETAILS]),
      requirementsTutee: RequirementsTuteeEntity.fromJson(json[REQUIREMENTS]),
      statsSimple: StatsSimpleEntity.fromJson(json[STATS_SIMPLE]),
    );
  }

  factory TuteeAssignmentEntity.fromDomainEntity(TuteeAssignment entity) {
    return TuteeAssignmentEntity(
      identityTutee: IdentityTuteeEntity.fromDomainEntity(entity.identity),
      detailsTutee: DetailsTuteeEntity.fromDomainEntity(entity.details),
      requirementsTutee:
          RequirementsTuteeEntity.fromDomainEntity(entity.requirements),
      statsSimple: entity.stats != null
          ? StatsSimpleEntity.fromDomainEntity(entity.stats)
          : null,
    );
  }
  final DetailsTuteeEntity _detailsTutee;
  final IdentityTuteeEntity _identityTutee;
  final RequirementsTuteeEntity _requirementsTutee;
  final StatsSimpleEntity _statsSimple;

  @override
  DetailsTuteeEntity get details => _detailsTutee;

  @override
  IdentityTuteeEntity get identity => _identityTutee;

  @override
  RequirementsTuteeEntity get requirements => _requirementsTutee;

  @override
  StatsSimpleEntity get stats => _statsSimple;

  @override
  TuteeAssignment toDomainEntity() {
    return TuteeAssignment(
      identityTutee: identity.toDomainEntity(),
      detailsTutee: details.toDomainEntity(),
      requirementsTutee: requirements.toDomainEntity(),
      statsSimple: stats?.toDomainEntity(),
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

  Map<String, dynamic> toDocumentSnapshot(
      {@required bool isNew, @required bool freeze}) {
    return <String, dynamic>{
      IDENTITY: identity.toFirebaseMap(),
      DETAILS: details.toFirebaseMap(isNew: isNew, freeze: freeze),
      REQUIREMENTS: requirements.toFirebaseMap(),
      STATS_SIMPLE: stats.toFirebaseMap(isNew: isNew),
    };
  }

  Map<String, dynamic> toApplicationJson() {
    return <String, dynamic>{
      IDENTITY: identity.toJson(),
      DETAILS: details.toJson(),
      REQUIREMENTS: requirements.toJson(),
    };
  }

  Map<String, dynamic> toApplicationMap(
      {@required bool isNew, @required bool freeze}) {
    return <String, dynamic>{
      IDENTITY: identity.toFirebaseMap(),
      DETAILS: details.toFirebaseMap(isNew: isNew, freeze: freeze),
      REQUIREMENTS: requirements.toFirebaseMap(),
    };
  }

  @override
  List<Object> get props => [
        _detailsTutee,
        _requirementsTutee,
        _identityTutee,
        _statsSimple,
      ];
  @override
  String toString() => '''TuteeAssignmentEntity(
      identityTutee: $identity,
      detailsTutee: $details,
      requirementsTutee: $requirements,
      stats: $stats
  )''';

  Map<String, dynamic> toNewDocumentSnapshot() {}

  Map<String, dynamic> toExistingDocumentSnapshot(dynamic data) {}
}
