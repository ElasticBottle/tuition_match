import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';

class TutorRequest extends Equatable {
  const TutorRequest({
    TutorProfile profile,
    ApplicationDates dates,
    ApplicationStatus status,
  })  : _profile = profile,
        _dates = dates,
        _status = status;

  final TutorProfile _profile;
  final ApplicationDates _dates;
  final ApplicationStatus _status;

  TutorProfile get profile => _profile;
  ApplicationDates get dates => _dates;
  ApplicationStatus get status => _status;

  @override
  List<Object> get props => [
        profile,
        dates,
        status,
      ];

  @override
  String toString() => '''OutboundTutorProfileRequest(
      profile: $profile, 
      dates: $dates, 
      status: $status
    )''';
}
