import 'package:cotor/domain/entities/post/tutee_assignment/details/detail_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/indentity/identity_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/requirements_tutee.dart';
import 'package:equatable/equatable.dart';

class TuteeAssignment extends Equatable {
  const TuteeAssignment({
    DetailsTutee detailsTutee,
    IdentityTutee identityTutee,
    RequirementsTutee requirementsTutee,
  })  : _detailsTutee = detailsTutee,
        _identityTutee = identityTutee,
        _requirementsTutee = requirementsTutee;

  final DetailsTutee _detailsTutee;
  final IdentityTutee _identityTutee;
  final RequirementsTutee _requirementsTutee;

  DetailsTutee get details => _detailsTutee;

  IdentityTutee get identity => _identityTutee;

  RequirementsTutee get requirements => _requirementsTutee;

  @override
  List<Object> get props => [
        _detailsTutee,
        _requirementsTutee,
        _identityTutee,
      ];

  @override
  String toString() => '''TuteeAssignment(
      identityTutee: $identity,
      detailsTutee: $details,
      requirementsTutee: $requirements,
  )''';
}
