import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    this.username,
    this.name,
    this.photoUrl,
    this.isTutor,
    this.isVerifiedAccount,
    this.isEmailVerified,
    this.isVerifiedTutor,
    this.userAssignments,
    this.profile,
  });
  final String username;
  final Name name;
  final String photoUrl;
  final bool isTutor;
  final bool isVerifiedAccount;
  final bool isEmailVerified;
  final bool isVerifiedTutor;
  final List<TuteeAssignment> userAssignments;
  final TutorProfile profile;

  User copyWith() {
    return User();
  }

  @override
  List<Object> get props => [];

  @override
  String toString() => '''User {
    
  }''';
}

class PrivateUserInfo extends Equatable {
  const PrivateUserInfo({
    this.email,
    this.isEmailVerified,
    this.phoneNum,
    this.nric,
    this.documentsUrl,
  });
  final String email;
  final bool isEmailVerified;
  final String phoneNum;
  final String nric;
  final List<String> documentsUrl;

  PrivateUserInfo copyWith() {
    return PrivateUserInfo();
  }

  @override
  List<Object> get props => [];

  @override
  String toString() => '''PrivateUserInfo {

  }''';
}

class UserFavourites extends Equatable {
  const UserFavourites({
    this.likedAssignments,
    this.likedTutorProfiles,
  });
  final List<TuteeAssignment> likedAssignments;
  final List<TutorProfile> likedTutorProfiles;
  @override
  List<Object> get props => [
        likedAssignments,
        likedTutorProfiles,
      ];

  @override
  String toString() => '''UserFavourites {
    likedAssignments: $likedAssignments , 
    likedTutorProfiles: $likedTutorProfiles , 
  }''';
}
