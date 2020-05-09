import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/post/tutor_profile/details/details_tutor.dart';
import 'package:cotor/domain/entities/post/tutor_profile/identity/indentity_tutors.dart';
import 'package:cotor/domain/entities/post/tutor_profile/requirements/requirements_tutor.dart';
import 'package:cotor/domain/entities/post/base_post/base_stats/stats_simple.dart';

class TutorProfile extends Equatable {
  const TutorProfile({
    DetailsTutor detailsTutor,
    IdentityTutor identityTutor,
    RequirementsTutor requirementsTutor,
    StatsSimple statsSimple,
  })  : _detailsTutor = detailsTutor,
        _identityTutor = identityTutor,
        _requirementsTutor = requirementsTutor,
        _statsSimple = statsSimple;

  final DetailsTutor _detailsTutor;
  final IdentityTutor _identityTutor;
  final RequirementsTutor _requirementsTutor;
  final StatsSimple _statsSimple;

  DetailsTutor get details => _detailsTutor;

  IdentityTutor get identity => _identityTutor;

  RequirementsTutor get requirements => _requirementsTutor;

  StatsSimple get stats => _statsSimple;

  @override
  List<Object> get props =>
      [_detailsTutor, _requirementsTutor, _identityTutor, _statsSimple];

  @override
  String toString() => '''TutorProfile(
        detailsTutor: $details, 
        identityTutor: $identity, 
        requirementsTutor: $requirements
        statsSimple: $stats
      )''';
}
