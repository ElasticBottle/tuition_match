import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends User {
  const UserModel({
    String username,
    Name name,
    String photoUrl,
    bool isTutor,
    bool isVerifiedAccount,
    bool isVerifiedTutor,
    List<TuteeAssignment> userAssignments,
    TutorProfile profile,
  }) : super(
          username: username,
          name: name,
          photoUrl: photoUrl,
          isTutor: isTutor,
          isVerifiedAccount: isVerifiedAccount,
          isVerifiedTutor: isVerifiedTutor,
          userAssignments: userAssignments,
          profile: profile,
        );
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json[USERNAME],
      name: json[NAME],
      photoUrl: json[PHOTOURL],
      isTutor: json[IS_TUTOR],
      isVerifiedAccount: json[IS_VERIFIED_ACCOUNT],
      isVerifiedTutor: json[IS_VERIFIED_TUTOR],
      userAssignments: json[USER_ASSIGNMENTS],
      profile: json[PROFILE],
    );
  }
  factory UserModel.fromFirebaseUser(FirebaseUser user) {
    return UserModel(
      photoUrl: user.photoUrl,
      username: user.displayName,
    );
  }
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    doc.data.addAll(<String, dynamic>{USERNAME: doc.documentID});
    return UserModel.fromJson(doc.data);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      USERNAME: username,
      NAME: name,
      PHOTOURL: photoUrl,
      IS_TUTOR: isTutor,
      IS_VERIFIED_ACCOUNT: isVerifiedAccount,
      IS_VERIFIED_TUTOR: isVerifiedTutor,
      USER_ASSIGNMENTS: userAssignments,
      PROFILE: profile,
    };
  }

  @override
  String toString() => '''UserModel {
    username : $username,
    name : $name,
    photoUrl : $photoUrl,
    isTutor : $isTutor,
    isVerifiedAccount : $isVerifiedAccount,
    isVerifiedTutor : $isVerifiedTutor,
    userAssignments : $userAssignments,
    profile : $profile,
  }''';
}
