import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';

abstract class User {
  Name get name;
  String get uid;
  String get photoUrl;
  bool get isTutor;
  bool get isVerifiedAccount;
  bool get isVerifiedTutor;
  bool get isEmailVerified;
  Map<String, TuteeAssignment> get userAssignments;
  TutorProfile get tutorProfile;
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

class WithheldInfo extends Equatable {
  const WithheldInfo({
    this.phoneNum,
  });
  final String phoneNum;

  @override
  List<Object> get props => [phoneNum];

  @override
  String toString() => 'WithheldInfo(phoneNum: $phoneNum)';
}
