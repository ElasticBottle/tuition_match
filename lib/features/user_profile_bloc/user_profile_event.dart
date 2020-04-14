part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class UserEnterHompage extends UserProfileEvent {}

class RefreshUserProfile extends UserProfileEvent {
  const RefreshUserProfile({this.user});
  final User user;
  @override
  String toString() => '''RefreshUserProfile { user : $user}''';
}

class AddUserAssignment extends UserProfileEvent {
  const AddUserAssignment({
    this.assignment,
  });
  final TuteeAssignment assignment;

  @override
  List<Object> get props => [assignment];

  @override
  String toString() => '''AddUserAssignment {
    assignment : $assignment, 
  }''';
}

class UpdateUserAssignment extends UserProfileEvent {
  const UpdateUserAssignment({
    this.assignment,
    this.assignmentId,
  });
  final String assignmentId;
  final TuteeAssignment assignment;

  @override
  List<Object> get props => [assignment, assignmentId];

  @override
  String toString() => '''UpdateUserAssignment {
    assignmentId : $assignmentId,
    assignment : $assignment, 
  }''';
}

class DelUserAssignment extends UserProfileEvent {
  const DelUserAssignment({
    this.assignmentId,
  });
  final String assignmentId;

  @override
  List<Object> get props => [assignmentId];

  @override
  String toString() => '''DelUserAssignment {
    assignmentId : $assignmentId,
  }''';
}

class AddUserProfile extends UserProfileEvent {
  const AddUserProfile({
    this.profile,
  });
  final TutorProfile profile;

  @override
  List<Object> get props => [profile];

  @override
  String toString() => '''AddUserProfile {
    profile : $profile, 
  }''';
}

class UpdateUserProfile extends UserProfileEvent {
  const UpdateUserProfile({
    this.profile,
  });
  final TutorProfile profile;

  @override
  List<Object> get props => [profile];

  @override
  String toString() => '''UpdateUserProfile {
    profile : $profile, 
  }''';
}

class AddProfilePhoto extends UserProfileEvent {
  @override
  String toString() => '''AddProfilePhoto {}''';
}
