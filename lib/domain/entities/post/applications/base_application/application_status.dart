import 'package:equatable/equatable.dart';

class ApplicationStatus extends Equatable {
  const ApplicationStatus(String status) : _status = status;

  final String _status;

  static const ApplicationStatus TO_REVIEW = ApplicationStatus('To Review');
  static const ApplicationStatus AWAITING_ACCEPTANCE =
      ApplicationStatus('Awaiting Acceptance');

  static const ApplicationStatus AWAITING_REVIEW =
      ApplicationStatus('Awaiting review');
  static const ApplicationStatus TO_ACCEPT = ApplicationStatus('to accept');

  static const ApplicationStatus DECLINED = ApplicationStatus('Declined');
  static const ApplicationStatus ACCEPTED = ApplicationStatus('Accepted');
  static const ApplicationStatus COMPLETED = ApplicationStatus('Graduated');
  static const ApplicationStatus DELETED = ApplicationStatus('Deleted');

  String get status => _status;

  @override
  List<Object> get props => [_status];

  @override
  String toString() => _status;
}
