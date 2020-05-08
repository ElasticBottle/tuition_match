import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/post/tutor_profile/details/details_tutor.dart';
import 'package:cotor/domain/entities/post/tutor_profile/identity/indentity_tutors.dart';
import 'package:cotor/domain/entities/post/tutor_profile/requirements/requirements_tutor.dart';

class TutorProfile extends Equatable {
  const TutorProfile({
    DetailsTutor detailsTutor,
    IdentityTutor identityTutor,
    RequirementsTutor requirementsTutor,
  })  : _detailsTutor = detailsTutor,
        _identityTutor = identityTutor,
        _requirementsTutor = requirementsTutor;

  final DetailsTutor _detailsTutor;
  final IdentityTutor _identityTutor;
  final RequirementsTutor _requirementsTutor;

  DetailsTutor get details => _detailsTutor;

  IdentityTutor get identity => _identityTutor;

  RequirementsTutor get requirements => _requirementsTutor;

  @override
  List<Object> get props => [
        _detailsTutor,
        _requirementsTutor,
        _identityTutor,
      ];

  @override
  String toString() => '''TutorProfile(
        detailsTutor: $details, 
        identityTutor: $identity, 
        requirementsTutor: $requirements
      )''';
}
