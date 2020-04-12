import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends User {
  const UserModel({
    Name name,
    String uid,
    String photoUrl,
    bool isTutor,
    bool isVerifiedAccount,
    bool isVerifiedTutor,
    bool isEmailVerified,
    List<TuteeAssignment> userAssignments,
    TutorProfile tutorProfile,
  }) : super(
          uid: uid,
          name: name,
          photoUrl: photoUrl,
          isTutor: isTutor,
          isVerifiedAccount: isVerifiedAccount,
          isVerifiedTutor: isVerifiedTutor,
          isEmailVerified: isEmailVerified,
          userAssignments: userAssignments,
          tutorProfile: tutorProfile,
        );
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json[NAME],
      uid: json[UID],
      photoUrl: json[PHOTOURL],
      isTutor: json[IS_TUTOR],
      isVerifiedAccount: json[IS_VERIFIED_ACCOUNT],
      isVerifiedTutor: json[IS_VERIFIED_TUTOR],
      isEmailVerified: json[IS_EMAIL_VERIFIED],
      userAssignments: json[USER_ASSIGNMENTS],
      tutorProfile: json[TUTOR_PROFILE],
    );
  }
  factory UserModel.fromFirebaseUser(FirebaseUser user) {
    return UserModel(
      photoUrl: user.photoUrl,
      uid: user.uid,
      isEmailVerified: user.isEmailVerified,
    );
  }
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    doc.data.addAll(<String, dynamic>{UID: doc.documentID});
    return UserModel.fromJson(doc.data);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      UID: uid,
      NAME: name,
      PHOTOURL: photoUrl,
      IS_TUTOR: isTutor,
      IS_VERIFIED_ACCOUNT: isVerifiedAccount,
      IS_VERIFIED_TUTOR: isVerifiedTutor,
      IS_EMAIL_VERIFIED: isEmailVerified,
      USER_ASSIGNMENTS: userAssignments,
      TUTOR_PROFILE: tutorProfile,
    };
  }

  @override
  String toString() => '''UserModel {
    uid : $uid,
    name : $name,
    photoUrl : $photoUrl,
    isTutor : $isTutor,
    isVerifiedAccount : $isVerifiedAccount,
    isVerifiedTutor : $isVerifiedTutor,
    isEmailVerified: $isEmailVerified,
    userAssignments : $userAssignments,
    tutorProfile : $tutorProfile,
  }''';
}
