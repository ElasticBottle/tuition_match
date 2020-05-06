import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';
import 'package:cotor/domain/entities/post/tutor_profile/details/details_tutor.dart';
import 'package:cotor/domain/entities/post/tutor_profile/identity/indentity_tutors.dart';

abstract class IncomingTutorApplication {
  IdentityTutor get identity;
  DetailsTutor get details;
  ApplicationDates get dates;
  ApplicationStatus get status;
}
