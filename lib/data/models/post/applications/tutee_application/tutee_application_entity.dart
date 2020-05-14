import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/data/models/post/applications/base_application/application_dates_entity.dart';
import 'package:cotor/data/models/post/applications/base_application/application_status_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/domain/entities/post/applications/application.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:meta/meta.dart';

class TuteeApplicationEntity extends Application<TuteeAssignmentEntity>
    implements EntityBase<Application> {
  const TuteeApplicationEntity({
    TuteeAssignmentEntity application,
    ApplicationStatusEntity applicationStatus,
    ApplicationDatesEntity applicationDates,
  })  : _application = application,
        _applicationStatus = applicationStatus,
        _applicationDates = applicationDates,
        super(
          application: application,
          applicationStatus: applicationStatus,
          applicationDates: applicationDates,
        );
  factory TuteeApplicationEntity.fromDocumentSnapshot(
      Map<String, dynamic> json, String postId) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return TuteeApplicationEntity(
      application: TuteeAssignmentEntity.fromDocumentSnapshot(
          json[APPLICATION_INFO], postId),
      applicationDates:
          ApplicationDatesEntity.fromFirebaseMap(json[APPLICATION_DATES]),
      applicationStatus:
          ApplicationStatusEntity.fromShortString(json[APPLICATION_STATUS]),
    );
  }
  factory TuteeApplicationEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return TuteeApplicationEntity(
      application: TuteeAssignmentEntity.fromJson(json[APPLICATION_INFO]),
      applicationDates:
          ApplicationDatesEntity.fromJson(json[APPLICATION_DATES]),
      applicationStatus:
          ApplicationStatusEntity.fromShortString(json[APPLICATION_STATUS]),
    );
  }
  factory TuteeApplicationEntity.fromDomainEntity(Application entity) {
    return TuteeApplicationEntity(
      applicationDates: ApplicationDatesEntity.fromDomainEntity(entity.dates),
      applicationStatus:
          ApplicationStatusEntity.fromDomainEntity(entity.status),
      application: TuteeAssignmentEntity.fromDomainEntity(entity.application),
    );
  }

  final TuteeAssignmentEntity _application;
  final ApplicationStatusEntity _applicationStatus;
  final ApplicationDatesEntity _applicationDates;

  @override
  TuteeAssignmentEntity get application => _application;

  @override
  ApplicationStatusEntity get status => _applicationStatus;

  @override
  ApplicationDatesEntity get dates => _applicationDates;

  @override
  Application toDomainEntity() {
    return Application<TuteeAssignment>(
      applicationDates: dates.toDomainEntity(),
      applicationStatus: status.toDomainEntity(),
      application: application.toDomainEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      APPLICATION_INFO: application.toApplicationJson(),
      APPLICATION_STATUS: status.toShortString(),
      APPLICATION_DATES: dates.toJson(),
    };
  }

  Map<String, dynamic> toDocumentSnapshot(
      {@required ApplicationDateType dateType,
      @required bool isNew,
      @required bool freeze}) {
    return <String, dynamic>{
      APPLICATION_INFO:
          application.toApplicationMap(isNew: isNew, freeze: freeze),
      APPLICATION_DATES: dates.toFirebaseMap(dateType: dateType),
      APPLICATION_STATUS: status.toShortString(),
    };
  }

  @override
  String toString() => '''StTuteeApplicationEntity(
      applicationDates: $dates,
      applicationStatus: $status,
      application: $application,
    ) ''';
}
