import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';

abstract class ApplyingToStudent {
  String get postId;
  ApplicationStatus get status;
  ApplicationDates get dates;
}
