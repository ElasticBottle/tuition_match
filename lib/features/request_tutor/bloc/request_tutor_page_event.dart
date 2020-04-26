part of 'request_tutor_page_bloc.dart';

abstract class RequestTutorPageEvent extends Equatable {
  const RequestTutorPageEvent();

  @override
  List<Object> get props => [];
}

class InitialiseProfileFields extends RequestTutorPageEvent {
  const InitialiseProfileFields({
    this.tutorProfile,
    this.userDetails,
  });
  final TutorProfileModel tutorProfile;
  final UserModel userDetails;

  @override
  List<Object> get props => [
        tutorProfile,
        userDetails,
      ];

  @override
  String toString() =>
      'InitialiseProfileFields(tutorProfile: $tutorProfile, userDetails: $userDetails)';
}
