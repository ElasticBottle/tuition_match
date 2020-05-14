import 'package:cotor/domain/entities/post/applications/application.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:meta/meta.dart';

import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/data/models/post/applications/base_application/application_dates_entity.dart';
import 'package:cotor/data/models/post/applications/base_application/application_status_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/tutor_profile_entity.dart';

class TutorApplicationEntity extends Application<TutorProfileEntity>
    implements EntityBase<Application> {
  const TutorApplicationEntity({
    TutorProfileEntity application,
    ApplicationDatesEntity applicationDates,
    ApplicationStatusEntity applicationStatus,
  })  : _application = application,
        _dates = applicationDates,
        _status = applicationStatus,
        super(
          application: application,
          applicationDates: applicationDates,
          applicationStatus: applicationStatus,
        );

  factory TutorApplicationEntity.fromDocumentSnapshot(
      Map<String, dynamic> json, String uid) {
    if (json == null || json.isEmpty) {
      return null;
    }

    return TutorApplicationEntity(
      application:
          TutorProfileEntity.fromDocumentSnapshot(json[APPLICATION_INFO], uid),
      applicationStatus:
          ApplicationStatusEntity.fromShortString(json[APPLICATION_STATUS]),
      applicationDates:
          ApplicationDatesEntity.fromFirebaseMap(json[APPLICATION_DATES]),
    );
  }
  factory TutorApplicationEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return TutorApplicationEntity(
      application: TutorProfileEntity.fromJson(json[APPLICATION_INFO]),
      applicationStatus:
          ApplicationStatusEntity.fromShortString(json[APPLICATION_STATUS]),
      applicationDates:
          ApplicationDatesEntity.fromJson(json[APPLICATION_DATES]),
    );
  }
  factory TutorApplicationEntity.fromDomainEntity(Application entity) {
    return TutorApplicationEntity(
      application: TutorProfileEntity.fromDomainEntity(entity.application),
      applicationStatus:
          ApplicationStatusEntity.fromDomainEntity(entity.status),
      applicationDates: ApplicationDatesEntity.fromDomainEntity(entity.dates),
    );
  }

  final TutorProfileEntity _application;
  final ApplicationDatesEntity _dates;
  final ApplicationStatusEntity _status;

  @override
  TutorProfileEntity get application => _application;
  @override
  ApplicationDatesEntity get dates => _dates;
  @override
  ApplicationStatusEntity get status => _status;

  @override
  Application toDomainEntity() {
    return Application<TutorProfile>(
      application: application.toDomainEntity(),
      applicationDates: dates.toDomainEntity(),
      applicationStatus: status.toDomainEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      APPLICATION_INFO: application.toApplicationJson(),
      APPLICATION_DATES: dates.toJson(),
      APPLICATION_STATUS: status.toShortString(),
    };
  }

  Map<String, dynamic> toDocumentSnapshot(
      {@required ApplicationDateType dateType,
      @required bool isNew,
      @required bool freeze}) {
    return <String, dynamic>{
      APPLICATION_INFO: application.toApplicationMap(
        isNew: isNew,
        freeze: freeze,
      ),
      APPLICATION_DATES: dates.toFirebaseMap(dateType: dateType),
      APPLICATION_STATUS: status.toShortString(),
    };
  }

  @override
  List<Object> get props => [
        application,
        dates,
        status,
      ];

  @override
  String toString() => '''TutorApplicationEntity(
      application: $application, 
      applicationDates: $dates, 
      applicationStatus: $status
    )''';
}
