import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/detail_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/indentity/identity_tutee.dart';

abstract class IncomingStudentApplication {
  IdentityTutee get identity;
  DetailsTutee get details;
  ApplicationStatus get status;
  ApplicationDates get dates;
}
