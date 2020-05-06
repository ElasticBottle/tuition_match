import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';

abstract class ApplyingToTutor {
  String get uid;
  ApplicationDates get dates;
  ApplicationStatus get satus;
}
