import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';

abstract class IncomingTutorApplication {
  TutorProfile get tutorInfo;
  ApplicationDates get dates;
  ApplicationStatus get status;
}
