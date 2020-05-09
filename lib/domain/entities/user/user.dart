import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';
import 'package:cotor/domain/entities/user/identity_user.dart';

class User extends Equatable {
  const User({
    IdentityUser identity,
    List<TuteeAssignment> assignments,
    TutorProfile profile,
  })  : _identity = identity,
        _assignments = assignments,
        _profile = profile;

  final IdentityUser _identity;
  final List<TuteeAssignment> _assignments;
  final TutorProfile _profile;

  IdentityUser get identity => _identity;
  List<TuteeAssignment> get assignments => _assignments;
  TutorProfile get profile => _profile;

  @override
  List<Object> get props => [
        identity,
        assignments,
        profile,
      ];

  @override
  String toString() => '''User(
        identity: $identity, 
        assignments: $assignments, 
        profile: $profile
      )''';
}

class PrivateUserInfo extends Equatable {
  const PrivateUserInfo({
    this.email,
    this.nric,
    this.documentsUrl,
  });
  final String email;
  final String nric;
  final List<String> documentsUrl;

  PrivateUserInfo copyWith() {
    return PrivateUserInfo();
  }

  @override
  List<Object> get props => [
        email,
        nric,
        documentsUrl,
      ];

  @override
  String toString() => '''PrivateUserInfo {
    email: $email, 
    nric: $nric,
    documentsUrl: $documentsUrl,
  }''';
}
