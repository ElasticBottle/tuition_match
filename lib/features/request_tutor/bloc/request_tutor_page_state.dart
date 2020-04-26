part of 'request_tutor_page_bloc.dart';

class RequestTutorPageState extends Equatable {
  const RequestTutorPageState({
    this.requestingProfile,
    this.userAssignments,
  });

  factory RequestTutorPageState.initial() {
    return RequestTutorPageState(
      requestingProfile: TutorProfileModel(),
      userAssignments: const {},
    );
  }

  final TutorProfileModel requestingProfile;
  final Map<String, TuteeAssignmentModel> userAssignments;

  RequestTutorPageState update({
    TutorProfileModel requestingProfile,
    Map<String, TuteeAssignmentModel> userAssignments,
  }) {
    return copyWith(
      requestingProfile: requestingProfile,
      userAssignments: userAssignments,
    );
  }

  RequestTutorPageState copyWith({
    TutorProfileModel requestingProfile,
    Map<String, TuteeAssignmentModel> userAssignments,
  }) {
    return RequestTutorPageState(
      requestingProfile: requestingProfile ?? this.requestingProfile,
      userAssignments: userAssignments ?? this.userAssignments,
    );
  }

  @override
  List<Object> get props => [
        requestingProfile,
        userAssignments,
      ];

  @override
  String toString() {
    return '''RequestTutorPageState(
      requestingProfile: $requestingProfile,
      userAssignments: $userAssignments,
    ''';
  }
}
