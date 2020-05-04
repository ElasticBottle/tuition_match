import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/datasources/firestore_path.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/tutee_assignment_entity.dart';
import 'package:cotor/data/models/tutor_profile_entity.dart';
import 'package:cotor/data/models/user_entity.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

abstract class UserRemoteDataSource {
  /// Returns a [Stream<UserEntity>] listening to the user public info
  /// Trigger everytime the logged in user updates the profile
  /// This includes changes to user's [TutorProfile] and [TuteeAssignment]
  /// This does no include changes to user's [RequestedTutors], [AppliedAssignments], and [Likes]
  Stream<UserEntity> userProfileStream(String uid);

  /// Returns [Future<UserEntity>].
  /// Throws [NoUserException] if document does not exist for that particulat [uid]
  /// Throw [ServerException] for all other errors.
  Future<UserEntity> getUserInfo(String uid);

  /// Throw [ServerException] for all errors.
  Future<PrivateUserInfo> getUserPrivateInfo(String uid);

  /// Throws [ServerException] for all errors
  Future<void> createNewUserDocument({
    String uid,
    String photoUrl,
    String firstname,
    String lastname,
    String phoneNum,
  });

  Future<bool> delAssignment({String postId, String uid});
  Future<bool> setTuteeAssignment({TuteeAssignmentEntity tuteeParams});
  Future<bool> updateTuteeAssignment({TuteeAssignmentEntity tuteeParams});

  Future<bool> delProfile({String uid});
  Future<bool> setTutorProfile({TutorProfileEntity tutorProfile});
  Future<bool> updateTutorProfile({TutorProfileEntity tutorProfile});

  Future<bool> requestTutor({
    String requestUid,
    TuteeAssignmentEntity assignment,
    bool isNewAssignment,
    bool toSave,
  });
}

class FirestoreUserDataSource implements UserRemoteDataSource {
  FirestoreUserDataSource({this.store, this.auth});
  final Firestore store;
  final FirebaseAuth auth;

  @override
  Stream<UserEntity> userProfileStream(String uid) {
    return store.document(FirestorePath.users(uid)).snapshots().map(
        (DocumentSnapshot userProfileDoc) =>
            UserEntity.fromDocumentSnapshot(userProfileDoc));
  }

  @override
  Future<void> createNewUserDocument({
    @required String uid,
    @required String photoUrl,
    @required String firstname,
    @required String lastname,
    @required String phoneNum,
  }) async {
    final DocumentReference publicInfo =
        store.document(FirestorePath.users(uid));
    final DocumentReference privateInfo =
        store.document(FirestorePath.usersPrivateInfo(uid));
    final DocumentReference requestedTutors =
        store.document(FirestorePath.userRequestedTutors(uid));
    final DocumentReference appliedAssignments =
        store.document(FirestorePath.userAppliedAssignments(uid));
    final DocumentReference likedTutors =
        store.document(FirestorePath.userAppliedAssignments(uid));
    final DocumentReference likedAssignments =
        store.document(FirestorePath.userAppliedAssignments(uid));
    final WriteBatch batch = store.batch();
    batch.setData(publicInfo, <String, dynamic>{
      NAME: <String, String>{
        FIRSTNAME: firstname,
        LASTNAME: lastname,
      },
      PHOTOURL: photoUrl,
      IS_TUTOR: false,
      IS_VERIFIED_TUTOR: false,
      IS_VERIFIED_ACCOUNT: false,
      USER_ASSIGNMENTS: <String, Map<String, dynamic>>{},
      TUTOR_PROFILE: <String, dynamic>{},
    });
    batch.setData(privateInfo, <String, dynamic>{
      PHONE_NUMBER: phoneNum,
    });
    batch.setData(requestedTutors, <String, dynamic>{});
    batch.setData(appliedAssignments, <String, dynamic>{});
    batch.setData(likedTutors, <String, dynamic>{});
    batch.setData(likedAssignments, <String, dynamic>{});
    try {
      await batch.commit();
    } catch (e) {
      print('user remote data source CreateNewUserDocument' + e.toString());
      throw ServerException();
    }
  }

  @override
  Future<UserEntity> getUserInfo(String uid) async {
    final DocumentReference ref = store.document(FirestorePath.users(uid));
    try {
      final DocumentSnapshot result = await ref.get();
      if (result.data == null) {
        throw NoUserException();
      }
      return UserEntity.fromDocumentSnapshot(result);
    } catch (e, stacktrace) {
      print(stacktrace);
      print('user remote data source getUserInfo ' + e.toString());
      if (e is NoUserException) {
        throw NoUserException();
      }
      throw ServerException();
    }
  }

  @override
  Future<PrivateUserInfo> getUserPrivateInfo(String uid) async {
    final DocumentReference privateRef =
        store.document(FirestorePath.usersPrivateInfo(uid));
    try {
      final DocumentSnapshot result = await privateRef.get();
      // TODO(ElasticBottle): figure out return type
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
      throw ServerException();
    }
  }

  @override
  Future<bool> delAssignment({String postId, String uid}) async {
    final DocumentReference userRef = store.document(FirestorePath.users(uid));
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot userSnapshot = await tx.get(userRef);
        final Map<String, Map<String, dynamic>> userAssignments =
            userSnapshot.data[USER_ASSIGNMENTS];
        userAssignments.remove(postId);
        tx.update(
            userRef, <String, dynamic>{USER_ASSIGNMENTS: userAssignments});
        tx.delete(store.document(FirestorePath.assignment(postId)));
      });
      return true;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> delProfile({String uid}) async {
    try {
      await store.runTransaction((Transaction tx) async {
        tx.update(store.document(FirestorePath.users(uid)),
            <String, dynamic>{TUTOR_PROFILE: '', IS_TUTOR: false});
        tx.delete(store.document(FirestorePath.tutorProfile(uid)));
      });
      return true;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> setTuteeAssignment({TuteeAssignmentEntity tuteeParams}) async {
    final DocumentReference userRef =
        store.document(FirestorePath.users(tuteeParams.uid));
    final String postId = Uuid().v1();

    try {
      await store.runTransaction(
        (Transaction tx) async {
          // creating assignment map to add
          final Map<String, dynamic> toAdd =
              tuteeParams.toNewDocumentSnapshot();
          toAdd.addAll(
            <String, dynamic>{
              DATE_ADDED: FieldValue.serverTimestamp(),
              DATE_MODIFIED: FieldValue.serverTimestamp(),
            },
          );

          // adding assignment map to user profile and assignment collection
          final DocumentSnapshot userSnapshot = await tx.get(userRef);
          userSnapshot.data[USER_ASSIGNMENTS][postId] = toAdd;
          tx.update(
            userRef,
            <String, Map<String, dynamic>>{
              USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
            },
          );
          tx.set(
            store.document(FirestorePath.assignment(postId)),
            toAdd,
          );
        },
      );
      return true;
    } catch (e, stacktrace) {
      print(e.toString() + ' ' + stacktrace.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> updateTuteeAssignment(
      {TuteeAssignmentEntity tuteeParams}) async {
    final DocumentReference userRef =
        store.document(FirestorePath.users(tuteeParams.uid));

    try {
      await store.runTransaction(
        (Transaction tx) async {
          final DocumentSnapshot userSnapshot = await tx.get(userRef);
          final String postId = tuteeParams.postId;

          // creating map to be used for update
          final Map<String, dynamic> toAdd =
              tuteeParams.toExistingDocumentSnapshot(
                  userSnapshot.data[USER_ASSIGNMENTS][postId]);
          toAdd[DATE_MODIFIED] = FieldValue.serverTimestamp();
          userSnapshot.data[USER_ASSIGNMENTS][postId] = toAdd;

          // updating user and assignment collections
          tx.update(
            userRef,
            <String, Map<String, dynamic>>{
              USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
            },
          );
          tx.update(
            store.document(FirestorePath.assignment(postId)),
            toAdd,
          );
        },
      );
      return true;
    } catch (e, stacktrace) {
      print(e.toString() + ' ' + stacktrace.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> setTutorProfile({TutorProfileEntity tutorProfile}) async {
    final Map<String, dynamic> toAdd = tutorProfile.toNewDocumentSnapshot();
    toAdd.addAll(
      <String, dynamic>{
        DATE_ADDED: FieldValue.serverTimestamp(),
        DATE_MODIFIED: FieldValue.serverTimestamp(),
      },
    );

    final WriteBatch batch = store.batch();
    batch.updateData(
      store.document(FirestorePath.users(tutorProfile.uid)),
      <String, dynamic>{
        TUTOR_PROFILE: toAdd,
        IS_TUTOR: true,
      },
    );
    batch.setData(
      store.document(FirestorePath.tutorProfile(tutorProfile.uid)),
      toAdd,
    );
    try {
      await batch.commit();
      return true;
    } catch (e, stacktrace) {
      print(stacktrace);
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> updateTutorProfile({TutorProfileEntity tutorProfile}) async {
    final DocumentReference tutorProfileRef =
        store.document(FirestorePath.tutorProfile(tutorProfile.uid));
    try {
      await store.runTransaction(
        (Transaction tx) async {
          final DocumentSnapshot profileSnapshot =
              await tx.get(tutorProfileRef);

          final Map<String, dynamic> toAdd =
              tutorProfile.toExistingDocumentSnapshot(profileSnapshot.data);
          toAdd[DATE_MODIFIED] = FieldValue.serverTimestamp();

          tx.update(
            store.document(FirestorePath.users(tutorProfile.uid)),
            <String, Map<String, dynamic>>{TUTOR_PROFILE: toAdd},
          );
          tx.update(
            tutorProfileRef,
            toAdd,
          );
        },
      );
      return true;
    } catch (e, stacktrace) {
      print(stacktrace);
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> requestTutor({
    String requestUid,
    TuteeAssignmentEntity assignment,
    bool isNewAssignment,
    bool toSave,
  }) async {
    final Map<String, dynamic> reqeust = <String, dynamic>{
      DETAILS: assignment.toJson(),
      DATE_REQUESTED: FieldValue.serverTimestamp(),
      APPLICATION_STATUS: 'PENDING',
    };

    if (isNewAssignment) {
      // New assignment postId
      final String postId = Uuid().v1();

      final Map<String, dynamic> requestRecord = <String, dynamic>{
        ASSIGNMENT_ID: postId,
        DATE_REQUESTED: FieldValue.serverTimestamp(),
        APPLICATION_STATUS: 'PENDING',
      };
      try {
        await store.runTransaction(
          (Transaction tx) async {
            final userRef = store.document(FirestorePath.users(assignment.uid));
            final userRequestTutorRef = store
                .document(FirestorePath.userRequestedTutors(assignment.uid));

            if (toSave) {
              // creating assignment map to add
              final Map<String, dynamic> toAdd =
                  assignment.toNewDocumentSnapshot();
              toAdd.addAll(
                <String, dynamic>{
                  DATE_ADDED: FieldValue.serverTimestamp(),
                  DATE_MODIFIED: FieldValue.serverTimestamp(),
                },
              );

              // adding assignment map to user profile and assignment collection
              final DocumentSnapshot userSnapshot = await tx.get(userRef);
              final Map<String, dynamic> toUpdate =
                  userSnapshot.data[USER_ASSIGNMENTS];
              toUpdate[postId] = toAdd;

              tx.update(
                userRef,
                <String, Map<String, dynamic>>{USER_ASSIGNMENTS: toUpdate},
              );
              tx.set(
                store.document(FirestorePath.assignment(postId)),
                toAdd,
              );
            }
            tx.update(
              userRequestTutorRef,
              <String, Map<String, dynamic>>{requestUid: requestRecord},
            );
            tx.set(
              store.document(
                FirestorePath.tutorRequests(
                  requestUid,
                  postId,
                ),
              ),
              reqeust,
            );
          },
        );
        return true;
      } catch (e, stacktrace) {
        print(e.toString() + ' ' + stacktrace.toString());
        throw ServerException();
      }
    } else {
      final Map<String, dynamic> requestRecord = <String, dynamic>{
        ASSIGNMENT_ID: assignment.postId,
        DATE_REQUESTED: FieldValue.serverTimestamp(),
        APPLICATION_STATUS: 'PENDING',
      };
      try {
        await store.runTransaction(
          (Transaction tx) async {
            final userRequestTutorRef = store
                .document(FirestorePath.userRequestedTutors(assignment.uid));

            tx.update(
              userRequestTutorRef,
              <String, dynamic>{requestUid: requestRecord},
            );
            tx.set(
              store.document(
                FirestorePath.tutorRequests(
                  requestUid,
                  assignment.postId,
                ),
              ),
              reqeust,
            );
            if (toSave) {}
          },
        );
        return true;
      } catch (e, stacktrace) {
        print(e.toString() + ' ' + stacktrace.toString());
        throw ServerException();
      }
    }
  }
}
