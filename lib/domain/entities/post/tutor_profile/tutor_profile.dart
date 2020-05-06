import 'package:cotor/domain/entities/post/tutor_profile/details/details_tutor.dart';
import 'package:cotor/domain/entities/post/tutor_profile/identity/indentity_tutors.dart';
import 'package:cotor/domain/entities/post/tutor_profile/requirements/requirements_tutor.dart';

abstract class TutorProfile {
  IdentityTutor get identity;
  DetailsTutor get details;
  RequirementsTutor get requirements;
}
