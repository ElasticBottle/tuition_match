import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';
import 'package:cotor/domain/entities/post/base_post/post_base.dart';
import 'package:equatable/equatable.dart';

class Application<T extends PostBase, S extends PostBase> extends Equatable {
  const Application({
    T applicationInfo,
    S requestedInfo,
    ApplicationStatus applicationStatus,
    ApplicationDates applicationDates,
  })  : _applicationInfo = applicationInfo,
        _requesterInfo = requestedInfo,
        _applicationStatus = applicationStatus,
        _applicationDates = applicationDates;

  final T _applicationInfo;
  final S _requesterInfo;
  final ApplicationStatus _applicationStatus;
  final ApplicationDates _applicationDates;

  T get applicationInfo => _applicationInfo;

  S get requestedInfo => _requesterInfo;

  ApplicationStatus get status => _applicationStatus;

  ApplicationDates get dates => _applicationDates;

  Application<T, S> reviewed() {
    return Application<T, S>(
      applicationInfo: applicationInfo,
      applicationDates: dates,
      applicationStatus: ApplicationStatus.AWAITING_ACCEPTANCE,
    );
  }

  Application<T, S> declined() {
    return Application<T, S>(
      applicationInfo: applicationInfo,
      requestedInfo: requestedInfo,
      applicationDates: dates,
      applicationStatus: ApplicationStatus.DECLINED,
    );
  }

  Application<T, S> accept() {
    return Application<T, S>(
      applicationInfo: applicationInfo,
      requestedInfo: requestedInfo,
      applicationDates: dates,
      applicationStatus: ApplicationStatus.ACCEPTED,
    );
  }

  Application<T, S> complete() {
    return Application<T, S>(
      applicationInfo: applicationInfo,
      requestedInfo: requestedInfo,
      applicationDates: dates,
      applicationStatus: ApplicationStatus.COMPLETED,
    );
  }

  Application<T, S> archive() {
    return Application<T, S>(
      applicationInfo: applicationInfo,
      requestedInfo: requestedInfo,
      applicationDates: dates,
      applicationStatus: ApplicationStatus.ARCHIVED,
    );
  }

  @override
  List<Object> get props => [
        _applicationDates,
        _applicationStatus,
        _applicationInfo,
        _requesterInfo,
      ];

  @override
  String toString() => '''Application(
      applicationInfo: $applicationInfo,
      requestedInfo: $requestedInfo,
      applicationDates: $dates,
      applicationStatus: $status,
    ) ''';
}
