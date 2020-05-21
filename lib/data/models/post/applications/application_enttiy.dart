import 'package:cotor/data/models/post/post_base._entity.dart';
import 'package:cotor/domain/entities/post/applications/application.dart';
import 'package:cotor/domain/entities/post/base_post/post_base.dart';
import 'package:meta/meta.dart';

import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/data/models/post/applications/base_application/application_dates_entity.dart';
import 'package:cotor/data/models/post/applications/base_application/application_status_entity.dart';

typedef Creator<T extends PostBaseEntity<U>, U> = T Function({
  U entity,
  Map<String, dynamic> json,
});

class ApplicationEntity<T extends PostBaseEntity<U>, U extends PostBase,
        S extends PostBaseEntity<V>, V extends PostBase>
    extends Application<T, S> implements EntityBase<Application> {
  const ApplicationEntity({
    T applicationInfo,
    S requestedInfo,
    ApplicationDatesEntity applicationDates,
    ApplicationStatusEntity applicationStatus,
  })  : _applicationInfo = applicationInfo,
        _requesterInfo = requestedInfo,
        _dates = applicationDates,
        _status = applicationStatus,
        super(
          applicationInfo: applicationInfo,
          requestedInfo: requestedInfo,
          applicationDates: applicationDates,
          applicationStatus: applicationStatus,
        );

  factory ApplicationEntity.fromDocumentSnapshot(Map<String, dynamic> json,
      {Creator<T, U> creatorApp, Creator<S, V> creatorReq}) {
    if (json == null || json.isEmpty) {
      return null;
    }

    return ApplicationEntity(
      applicationInfo: creatorApp(json: json[APPLICATION_INFO]),
      requestedInfo: creatorReq(json: json[REQUESTER_INFO]),
      applicationStatus:
          ApplicationStatusEntity.fromShortString(json[APPLICATION_STATUS]),
      applicationDates:
          ApplicationDatesEntity.fromFirebaseMap(json[APPLICATION_DATES]),
    );
  }
  factory ApplicationEntity.fromJson(Map<String, dynamic> json,
      {Creator<T, U> creator, Creator<S, V> creatorReq}) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return ApplicationEntity(
      applicationInfo: creator(json: json[APPLICATION_INFO]),
      requestedInfo: creatorReq(json: json[REQUESTER_INFO]),
      applicationStatus:
          ApplicationStatusEntity.fromShortString(json[APPLICATION_STATUS]),
      applicationDates:
          ApplicationDatesEntity.fromJson(json[APPLICATION_DATES]),
    );
  }
  factory ApplicationEntity.fromDomainEntity(Application entity,
      {Creator<T, U> creator, Creator<S, V> creatorReq}) {
    return ApplicationEntity(
      applicationInfo: creator(entity: entity.applicationInfo),
      requestedInfo: creatorReq(entity: entity.requestedInfo),
      applicationStatus:
          ApplicationStatusEntity.fromDomainEntity(entity.status),
      applicationDates: ApplicationDatesEntity.fromDomainEntity(entity.dates),
    );
  }

  final T _applicationInfo;
  final S _requesterInfo;
  final ApplicationDatesEntity _dates;
  final ApplicationStatusEntity _status;

  @override
  T get applicationInfo => _applicationInfo;
  @override
  S get requestedInfo => _requesterInfo;
  @override
  ApplicationDatesEntity get dates => _dates;
  @override
  ApplicationStatusEntity get status => _status;

  @override
  Application toDomainEntity() {
    return Application<U, V>(
      applicationInfo: applicationInfo.toDomainEntity(),
      requestedInfo: requestedInfo.toDomainEntity(),
      applicationDates: dates.toDomainEntity(),
      applicationStatus: status.toDomainEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      APPLICATION_INFO: applicationInfo.toApplicationJson(),
      REQUESTER_INFO: requestedInfo.toApplicationJson(),
      APPLICATION_DATES: dates.toJson(),
      APPLICATION_STATUS: status.toShortString(),
    };
  }

  Map<String, dynamic> toRequestedInfoDocumentSnapshot({
    @required ApplicationDateType dateType,
  }) {
    return <String, dynamic>{
      APPLICATION_INFO: requestedInfo.toApplicationMap(
        isNew: false,
        freeze: true,
      ),
      APPLICATION_DATES: dates.toFirebaseMap(dateType: dateType),
      APPLICATION_STATUS: status.toShortString(),
    };
  }

  Map<String, dynamic> toApplicantInfoDocumentSnapshot({
    @required ApplicationDateType dateType,
    @required bool isNew,
  }) {
    return <String, dynamic>{
      APPLICATION_INFO: applicationInfo.toApplicationMap(
        isNew: isNew,
        freeze: false,
      ),
      APPLICATION_DATES: dates.toFirebaseMap(dateType: dateType),
      APPLICATION_STATUS:
          ApplicationStatusEntity.fromDomainEntity(status.opposingUserStatus())
              .toShortString(),
    };
  }

  @override
  List<Object> get props => [
        applicationInfo,
        requestedInfo,
        dates,
        status,
      ];

  @override
  String toString() => '''ApplicationEntity(
      applicationInfo: $applicationInfo, 
      requestedInfo: $requestedInfo,
      applicationDates: $dates, 
      applicationStatus: $status
    )''';
}
