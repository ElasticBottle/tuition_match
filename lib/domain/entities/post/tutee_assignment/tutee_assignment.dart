import 'package:cotor/domain/entities/post/base_post/base_stats/stats_simple.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/detail_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/indentity/identity_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/requirements_tutee.dart';
import 'package:equatable/equatable.dart';

class TuteeAssignment extends Equatable {
  const TuteeAssignment({
    DetailsTutee detailsTutee,
    IdentityTutee identityTutee,
    RequirementsTutee requirementsTutee,
    StatsSimple statsSimple,
  })  : _detailsTutee = detailsTutee,
        _identityTutee = identityTutee,
        _requirementsTutee = requirementsTutee,
        _statsSimple = statsSimple;

  final DetailsTutee _detailsTutee;
  final IdentityTutee _identityTutee;
  final RequirementsTutee _requirementsTutee;
  final StatsSimple _statsSimple;

  DetailsTutee get details => _detailsTutee;

  IdentityTutee get identity => _identityTutee;

  RequirementsTutee get requirements => _requirementsTutee;

  StatsSimple get stats => _statsSimple;

  @override
  List<Object> get props => [
        _detailsTutee,
        _requirementsTutee,
        _identityTutee,
        _statsSimple,
      ];

  @override
  String toString() => '''TuteeAssignment(
      identityTutee: $identity,
      detailsTutee: $details,
      requirementsTutee: $requirements,
      statsSimple: $stats,
  )''';
}
