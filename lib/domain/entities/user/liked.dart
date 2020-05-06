import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';

abstract class Liked {
  Map<String, TuteeAssignment> get assignments;
  Map<String, TutorProfile> get profiles;
}
