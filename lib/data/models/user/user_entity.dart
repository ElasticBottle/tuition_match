import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/tutor_profile_entity.dart';
import 'package:cotor/data/models/user/identity_user_entity.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserEntity extends User implements EntityBase<User> {
  const UserEntity({
    IdentityUserEntity identity,
    Map<String, TuteeAssignmentEntity> assignments,
    TutorProfileEntity profile,
  })  : _assignments = assignments,
        _identity = identity,
        _profile = profile,
        super(
          assignments: assignments,
          identity: identity,
          profile: profile,
        );

  factory UserEntity.fromDocumentSnapshot(
      Map<String, dynamic> json, String uid) {
    if (json == null || json.isEmpty) {
      return null;
    }
    json[USER_IDENTITY][UID] = uid;
    final Map<String, dynamic> toConvert = json[USER_ASSIGNMENTS];
    final Map<String, TuteeAssignmentEntity> userAssignments = {};
    for (MapEntry<String, dynamic> entry in toConvert.entries) {
      userAssignments.addAll({
        entry.key:
            TuteeAssignmentEntity.fromDocumentSnapshot(entry.value, entry.key)
      });
    }
    return UserEntity(
      identity: IdentityUserEntity.fromJson(json[USER_IDENTITY]),
      assignments: userAssignments,
      profile: TutorProfileEntity.fromDocumentSnapshot(json[USER_PROFILE], uid),
    );
  }

  factory UserEntity.fromFirebaseUser(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return UserEntity(
      identity: IdentityUserEntity(
        photoUrl: user.photoUrl,
        uid: user.uid,
        isEmailVerified: user.isEmailVerified,
      ),
    );
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    final Map<String, dynamic> toConvert = json[USER_ASSIGNMENTS];
    final Map<String, TuteeAssignmentEntity> userAssignments = {};
    for (MapEntry<String, dynamic> entry in toConvert.entries) {
      userAssignments.addAll({
        entry.key: TuteeAssignmentEntity.fromJson(entry.value),
      });
    }
    return UserEntity(
      identity: IdentityUserEntity.fromJson(json[USER_IDENTITY]),
      assignments: userAssignments,
      profile: TutorProfileEntity.fromJson(json[USER_PROFILE]),
    );
  }

  factory UserEntity.fromDomainEntity(User entity) {
    return UserEntity(
      assignments: entity.assignments.map((key, value) =>
          MapEntry(key, TuteeAssignmentEntity.fromDomainEntity(value))),
      identity: IdentityUserEntity.fromDomainEntity(entity.identity),
      profile: TutorProfileEntity.fromDomainEntity(entity.profile),
    );
  }

  final IdentityUserEntity _identity;
  final Map<String, TuteeAssignmentEntity> _assignments;
  final TutorProfileEntity _profile;

  @override
  Map<String, TuteeAssignmentEntity> get assignments => _assignments;

  @override
  IdentityUserEntity get identity => _identity;

  @override
  TutorProfileEntity get profile => _profile;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      USER_IDENTITY: identity.toJson(),
      USER_ASSIGNMENTS:
          assignments.map((key, value) => MapEntry(key, value.toJson())),
      USER_PROFILE: profile.toJson(),
    };
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return <String, dynamic>{
      USER_IDENTITY: identity.toFirebaesMap(),
      USER_ASSIGNMENTS: assignments.isEmpty
          ? <String, dynamic>{}
          : assignments.map(
              (key, value) => MapEntry(
                  key, value.toDocumentSnapshot(isNew: false, freeze: true)),
            ),
      USER_PROFILE: profile?.toDocumentSnapshot(isNew: false, freeze: true),
    };
  }

  @override
  User toDomainEntity() {
    return User(
      identity: identity.toDomainEntity(),
      assignments: assignments?.map(
        (key, value) => MapEntry(key, value.toDomainEntity()),
      ),
      profile: profile?.toDomainEntity(),
    );
  }

  @override
  String toString() => '''UserEntity(
        identity: $identity, 
        assignments: $assignments, 
        profile: $profile
      )''';
}
