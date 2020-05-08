import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:equatable/equatable.dart';

class IncomingStudentApplication extends Equatable {
  const IncomingStudentApplication({
    TuteeAssignment tuteeInfo,
    ApplicationStatus applicationStatus,
    ApplicationDates applicationDates,
  })  : _tuteeInfo = tuteeInfo,
        _applicationStatus = applicationStatus,
        _applicationDates = applicationDates;

  final TuteeAssignment _tuteeInfo;
  final ApplicationStatus _applicationStatus;
  final ApplicationDates _applicationDates;

  TuteeAssignment get tuteeInfo => _tuteeInfo;

  ApplicationStatus get status => _applicationStatus;

  ApplicationDates get dates => _applicationDates;

  @override
  List<Object> get props => [
        _applicationDates,
        _applicationStatus,
        tuteeInfo,
      ];

  @override
  String toString() => '''IncomingStudentApplication(
      applicationDates: $dates,
      applicationStatus: $status,
      tuteeInfo: $tuteeInfo,
    ) ''';
}
