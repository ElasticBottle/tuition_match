import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';
import 'package:equatable/equatable.dart';

class Application<T> extends Equatable {
  const Application({
    T application,
    ApplicationStatus applicationStatus,
    ApplicationDates applicationDates,
  })  : _application = application,
        _applicationStatus = applicationStatus,
        _applicationDates = applicationDates;

  final T _application;
  final ApplicationStatus _applicationStatus;
  final ApplicationDates _applicationDates;

  T get application => _application;

  ApplicationStatus get status => _applicationStatus;

  ApplicationDates get dates => _applicationDates;

  @override
  List<Object> get props => [
        _applicationDates,
        _applicationStatus,
        application,
      ];

  @override
  String toString() => '''Application(
      application: $application,
      applicationDates: $dates,
      applicationStatus: $status,
    ) ''';
}
