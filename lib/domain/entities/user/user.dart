import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/user/liked.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';
import 'package:cotor/domain/entities/user/identity_user.dart';

abstract class User {
  IdentityUser get identity;
  Map<String, TuteeAssignment> get assignments;
  TutorProfile get tutorProfile;
  Liked get liked;
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
