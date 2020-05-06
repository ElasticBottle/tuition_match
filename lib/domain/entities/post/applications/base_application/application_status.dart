import 'package:equatable/equatable.dart';

class ApplicationStatus extends Equatable {
  const ApplicationStatus._(this._status);
  final String _status;

  static const ApplicationStatus AWAITING_USER_REVIEW =
      ApplicationStatus._('Awaiting Review');
  static const ApplicationStatus AWAITING_OTHERS_CONFIRMATION =
      ApplicationStatus._('Awaiting other\'s confirmation');

  static const ApplicationStatus AWAITING_OTHERS_REVIEW =
      ApplicationStatus._('Awaiting other\'s review');
  static const ApplicationStatus AWAITING_USER_CONFIRMATION =
      ApplicationStatus._('Awaiting  confirmation');

  static const ApplicationStatus DECLINED = ApplicationStatus._('Deleted');
  static const ApplicationStatus ACCEPTED = ApplicationStatus._('Accepted');
  static const ApplicationStatus COMPLETED = ApplicationStatus._('Graduated');
  static const ApplicationStatus DELETED = ApplicationStatus._('Deleted');

  @override
  List<Object> get props => [_status];

  @override
  String toString() => _status;
}
