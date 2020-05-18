import 'package:equatable/equatable.dart';

const String toReview = 'To Review';
const String awaitingAcceptance = 'Awaiting Acceptance';
const String awaitingReview = 'Awaiting Review';
const String toAccept = 'To Accept';
const String declined = 'Declined';
const String accepted = 'Accepted';
const String completed = 'Completed';
const String archived = 'Archived';

class ApplicationStatus extends Equatable {
  const ApplicationStatus(String status) : _status = status;

  final String _status;

  static const ApplicationStatus TO_REVIEW = ApplicationStatus(toReview);
  static const ApplicationStatus AWAITING_ACCEPTANCE =
      ApplicationStatus(awaitingAcceptance);

  static const ApplicationStatus AWAITING_REVIEW =
      ApplicationStatus(awaitingReview);
  static const ApplicationStatus TO_ACCEPT = ApplicationStatus(toAccept);

  static const ApplicationStatus DECLINED = ApplicationStatus(declined);
  static const ApplicationStatus ACCEPTED = ApplicationStatus(accepted);
  static const ApplicationStatus COMPLETED = ApplicationStatus(completed);
  static const ApplicationStatus ARCHIVED = ApplicationStatus(archived);

  String get status => _status;

  ApplicationStatus opposingUserStatus() {
    if (status == toReview) {
      return AWAITING_REVIEW;
    } else if (status == awaitingReview) {
      return TO_REVIEW;
    } else if (status == toAccept) {
      return AWAITING_ACCEPTANCE;
    } else if (status == awaitingAcceptance) {
      return TO_ACCEPT;
    } else if (status == declined) {
      return DECLINED;
    } else if (status == accepted) {
      return ACCEPTED;
    } else if (status == completed) {
      return COMPLETED;
    } else {
      return this;
    }
  }

  @override
  List<Object> get props => [_status];

  @override
  String toString() => _status;
}
