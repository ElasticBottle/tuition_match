import 'package:cotor/domain/entities/core/requirements_base.dart';
import 'package:cotor/domain/entities/post/base_post/gender.dart';
import 'package:cotor/domain/entities/post/base_post/tutor_occupation.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/frequency.dart';

abstract class RequirementsTutee extends RequirementsBase {
  TutorOccupation get tutorOccupation;
  Gender get tutorGender;
  Frequency get freq;
}
