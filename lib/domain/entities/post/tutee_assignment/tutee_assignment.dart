import 'package:cotor/domain/entities/post/tutee_assignment/details/detail_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/indentity/identity_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/requirements_tutee.dart';

abstract class TuteeAssignment {
  IdentityTutee get indentity;
  DetailsTutee get details;
  RequirementsTutee get requirements;
}
