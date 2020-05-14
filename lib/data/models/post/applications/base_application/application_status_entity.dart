import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';

const String toReviewShort = 'ToR';
const String awaitingAcceptanceShort = 'AwaitA';
const String awaitingReviewShort = 'AwaitR';
const String toAcceptShort = 'ToA';
const String declinedShort = 'Dec';
const String acceptedShort = 'Accept';
const String completedShort = 'Done';
const String archivedShort = 'Archived';

class ApplicationStatusEntity extends ApplicationStatus
    implements EntityBase<ApplicationStatus> {
  const ApplicationStatusEntity(String status) : super(status);

  factory ApplicationStatusEntity.fromShortString(String state) {
    switch (state) {
      case toReviewShort:
        return ApplicationStatusEntity(toReview);
      case awaitingAcceptanceShort:
        return ApplicationStatusEntity(awaitingAcceptance);
      case awaitingReviewShort:
        return ApplicationStatusEntity(awaitingReview);
      case toAcceptShort:
        return ApplicationStatusEntity(toAccept);
      case declinedShort:
        return ApplicationStatusEntity(declined);
      case acceptedShort:
        return ApplicationStatusEntity(accepted);
      case completedShort:
        return ApplicationStatusEntity(completed);
      case archivedShort:
        return ApplicationStatusEntity(archived);
      default:
        return ApplicationStatusEntity(state);
    }
  }

  factory ApplicationStatusEntity.fromDomainEntity(ApplicationStatus entity) {
    return ApplicationStatusEntity(entity.status);
  }

  String toShortString() {
    switch (status) {
      case toReview:
        return toReviewShort;
      case awaitingAcceptance:
        return awaitingAcceptanceShort;
      case awaitingReview:
        return awaitingReviewShort;
      case toAccept:
        return toAcceptShort;
      case declined:
        return declinedShort;
      case accepted:
        return acceptedShort;
      case completed:
        return completedShort;
      case archived:
        return archivedShort;
      default:
        return status;
    }
  }

  @override
  ApplicationStatus toDomainEntity() {
    return ApplicationStatus(status);
  }
}
