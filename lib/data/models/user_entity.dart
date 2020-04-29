import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/name_entity.dart';
import 'package:cotor/data/models/tutee_assignment_entity.dart';
import 'package:cotor/data/models/tutor_profile_entity.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEntity extends Equatable implements User {
  UserEntity({
    Name name,
    String uid,
    String photoUrl,
    bool isTutor,
    bool isVerifiedAccount,
    bool isVerifiedTutor,
    bool isEmailVerified,
    Map<String, TuteeAssignment> userAssignments,
    TutorProfile tutorProfile,
  })  : _name = name == null ? null : NameEntity.fromDomainEntity(name),
        _uid = uid,
        _photoUrl = photoUrl,
        _isTutor = isTutor,
        _isVerifiedAccount = isVerifiedAccount,
        _isVerifiedTutor = isVerifiedTutor,
        _isEmailVerified = isEmailVerified,
        _userAssignments = userAssignments?.map((key, value) =>
            MapEntry(key, TuteeAssignmentEntity.fromDomainEntity(value))),
        _tutorProfile = TutorProfileEntity.fromDomainEntity(tutorProfile);
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> toConvert = json[USER_ASSIGNMENTS];
    final Map<String, TuteeAssignmentEntity> userAssignments = {};
    for (MapEntry<String, dynamic> entry in toConvert.entries) {
      userAssignments.addAll({
        entry.key: TuteeAssignmentEntity.fromJson(entry.value),
      });
    }
    return UserEntity(
      name: NameEntity.fromJson(json[NAME]),
      uid: json[UID],
      photoUrl: json[PHOTOURL],
      isTutor: json[IS_TUTOR],
      isVerifiedAccount: json[IS_VERIFIED_ACCOUNT],
      isVerifiedTutor: json[IS_VERIFIED_TUTOR],
      userAssignments: userAssignments,
      tutorProfile: TutorProfileEntity.fromJson(json[TUTOR_PROFILE]),
    );
  }
  factory UserEntity.fromFirebaseUser(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return UserEntity(
      photoUrl: user.photoUrl,
      uid: user.uid,
      isEmailVerified: user.isEmailVerified,
    );
  }
  factory UserEntity.fromDocumentSnapshot(DocumentSnapshot doc) {
    final Map<String, dynamic> toConvert = doc.data;
    toConvert.addAll(<String, dynamic>{UID: doc.documentID});
    return UserEntity.fromJson(toConvert);
  }

  factory UserEntity.fromDomainEntity(User user) {
    if (user == null) {
      return null;
    }
    return UserEntity(
      name: user.name,
      photoUrl: user.photoUrl,
      uid: user.uid,
      isEmailVerified: user.isEmailVerified,
      isTutor: user.isTutor,
      isVerifiedTutor: user.isVerifiedTutor,
      isVerifiedAccount: user.isVerifiedAccount,
      tutorProfile: user.tutorProfile,
      userAssignments: user.userAssignments,
    );
  }

  final NameEntity _name;
  final String _uid;
  final String _photoUrl;
  final bool _isTutor;
  final bool _isVerifiedAccount;
  final bool _isVerifiedTutor;
  final bool _isEmailVerified;
  final Map<String, TuteeAssignmentEntity> _userAssignments;
  final TutorProfileEntity _tutorProfile;

  @override
  NameEntity get name => _name;
  @override
  String get uid => _uid;
  @override
  String get photoUrl => _photoUrl;
  @override
  bool get isTutor => _isTutor;
  @override
  bool get isVerifiedAccount => _isVerifiedAccount;
  @override
  bool get isVerifiedTutor => _isVerifiedTutor;
  @override
  bool get isEmailVerified => _isEmailVerified;
  @override
  Map<String, TuteeAssignmentEntity> get userAssignments => _userAssignments;
  @override
  TutorProfileEntity get tutorProfile => _tutorProfile;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      UID: uid,
      NAME: name?.toJson(),
      PHOTOURL: photoUrl,
      IS_TUTOR: isTutor,
      IS_VERIFIED_ACCOUNT: isVerifiedAccount,
      IS_VERIFIED_TUTOR: isVerifiedTutor,
      IS_EMAIL_VERIFIED: isEmailVerified,
      USER_ASSIGNMENTS: userAssignments,
      TUTOR_PROFILE: tutorProfile,
    };
  }

  User toDomainEntity() {
    return UserEntity(
        uid: uid,
        isEmailVerified: isEmailVerified,
        isTutor: isTutor,
        isVerifiedAccount: isVerifiedAccount,
        isVerifiedTutor: isVerifiedTutor,
        name: name?.toDomainEntity(),
        photoUrl: photoUrl,
        tutorProfile: tutorProfile?.toDomainEntity(),
        userAssignments: userAssignments
            ?.map((key, value) => MapEntry(key, value?.toDomainEntity())));
  }

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
    return UserEntity(
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
