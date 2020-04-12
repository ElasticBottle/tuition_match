import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.name,
    this.uid,
    this.photoUrl,
    this.isTutor,
    this.isVerifiedAccount,
    this.isVerifiedTutor,
    this.isEmailVerified,
    this.userAssignments,
    this.tutorProfile,
  });
  final Name name;
  final String uid;
  final String photoUrl;
  final bool isTutor;
  final bool isVerifiedAccount;
  final bool isVerifiedTutor;
  final bool isEmailVerified;
  final List<TuteeAssignment> userAssignments;
  final TutorProfile tutorProfile;

  User copyWith(
    String username,
    Name name,
    String uid,
    String photoUrl,
    bool isTutor,
    bool isVerifiedAccount,
    bool isVerifiedTutor,
    bool isEmailVerified,
    List<TuteeAssignment> userAssignments,
    TutorProfile tutorProfile,
  ) {
    return User(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      isTutor: isTutor ?? this.isTutor,
      isVerifiedAccount: isVerifiedAccount ?? this.isVerifiedAccount,
      isVerifiedTutor: isVerifiedTutor ?? this.isVerifiedTutor,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      userAssignments: userAssignments ?? this.userAssignments,
      tutorProfile: tutorProfile ?? this.tutorProfile,
    );
  }

  @override
  List<Object> get props => [
        name,
        uid,
        photoUrl,
        isTutor,
        isVerifiedAccount,
        isVerifiedTutor,
        isEmailVerified,
        userAssignments,
        tutorProfile,
      ];

  @override
  String toString() => '''User {
    name : $name,
    uid : $uid,
    photoUrl : $photoUrl,
    isTutor : $isTutor,
    isVerifiedAccount : $isVerifiedAccount,
    isVerifiedTutor : $isVerifiedTutor,
    isEmailVerified : $isEmailVerified,
    userAssignments : $userAssignments,
    profile : $tutorProfile,
  }''';
}

class PrivateUserInfo extends Equatable {
  const PrivateUserInfo({
    this.phoneNum,
    this.nric,
    this.documentsUrl,
  });
  final String phoneNum;
  final String nric;
  final List<String> documentsUrl;

  PrivateUserInfo copyWith() {
    return PrivateUserInfo();
  }

  @override
  List<Object> get props => [
        phoneNum,
        nric,
        documentsUrl,
      ];

  @override
  String toString() => '''PrivateUserInfo {
    phoneNum: $phoneNum,
    nric: $nric,
    documentsUrl: $documentsUrl,
  }''';
}

class WithheldInfo extends Equatable {
  const WithheldInfo({this.email});
  final String email;
  @override
  List<Object> get props => [email];

  @override
  String toString() => 'withheldInfo {email: $email}';
}
