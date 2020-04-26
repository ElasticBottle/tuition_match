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
  Stream<UserEntity> get userStream;
  Stream<UserEntity> userProfileStream(String uid);

  Future<UserEntity> getCurrentUser();
  Future<UserEntity> getUserInfo(String uid);
  Future<PrivateUserInfo> getUserPrivateInfo(String uid);
  Future<void> createNewUserDocument({
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
  });
}

class FirestoreUserDataSource implements UserRemoteDataSource {
  FirestoreUserDataSource({this.store, this.auth});
  final Firestore store;
  final FirebaseAuth auth;

  @override
  Stream<UserEntity> get userStream {
    return auth.onAuthStateChanged
        .map((event) => UserEntity.fromFirebaseUser(event));
  }

  @override
  Stream<UserEntity> userProfileStream(String uid) {
    return store.document(FirestorePath.users(uid)).snapshots().map(
        (DocumentSnapshot userProfileDoc) =>
            UserEntity.fromDocumentSnapshot(userProfileDoc));
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    if (user == null) {
      throw NoUserException();
    }
    user.reload();
    final FirebaseUser newUser = await auth.currentUser();
    return UserEntity.fromFirebaseUser(newUser);
  }

  @override
  Future<void> createNewUserDocument({
    @required String firstname,
    @required String lastname,
    @required String phoneNum,
  }) async {
    final UserEntity user = await getCurrentUser();
    final DocumentReference ref = store.document(FirestorePath.users(user.uid));
    try {
      await ref.setData(<String, dynamic>{
        NAME: <String, String>{
          FIRSTNAME: firstname,
          LASTNAME: lastname,
        },
        PHOTOURL: user.photoUrl,
        IS_TUTOR: false,
        IS_VERIFIED_TUTOR: false,
        IS_VERIFIED_ACCOUNT: false,
        USER_ASSIGNMENTS: <String, Map<String, dynamic>>{},
        TUTOR_PROFILE: <String, dynamic>{},
      });
      // await ref.setData(<String, dynamic>{
      //   PHONE_NUMBER: phoneNum,
      // });
      return;
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
    // Firestore.instance
    // .collection("users")
    // .document(currentUser.uid)
    // .get()
  }

  @override
  Future<PrivateUserInfo> getUserPrivateInfo(String uid) {
    // TODO: implement getUserPrivateInfo
    throw UnimplementedError();
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
        tx.delete(store.document(FirestorePath.likeAssignment(postId)));
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
        tx.delete(store.document(FirestorePath.likeProfiles(uid)));
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
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot userSnapshot = await tx.get(userRef);
        final String postId = Uuid().v1();
        final Map<String, dynamic> toAdd = tuteeParams.toDocumentSnapshot()[1];
        toAdd.addAll(<String, dynamic>{
          DATE_ADDED: FieldValue.serverTimestamp(),
          NUM_APPLIED: 0,
          NUM_LIKED: 0,
        });
        userSnapshot.data[USER_ASSIGNMENTS]
            .addAll(<String, Map<String, dynamic>>{postId: toAdd});
        tx.update(
            store.document(FirestorePath.users(tuteeParams.uid)),
            <String, Map<String, dynamic>>{
              USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
            });
        tx.set(store.document(FirestorePath.assignment(postId)), toAdd);
        // TODO(ElasticBottle): Change toAdd here take a Map<uid, photoURL> under liked key
        tx.set(store.document(FirestorePath.likeAssignment(postId)), toAdd);
      });
      return true;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> setTutorProfile({TutorProfileEntity tutorProfile}) async {
    final Map<String, dynamic> toAdd = tutorProfile.toDocumentSnapshot()[1];
    toAdd.addAll(<String, dynamic>{
      UID: tutorProfile.uid,
      DATE_ADDED: FieldValue.serverTimestamp(),
      DATE_MODIFIED: FieldValue.serverTimestamp(),
      NUM_REQUEST: 0,
      NUM_LIKED: 0,
      NUM_CLICKS: 0,
      RATING: 0.0,
    });
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
    toAdd.addAll(<String, Map<String, String>>{LIKED: <String, String>{}});
    batch.setData(
      store.document(FirestorePath.likeProfiles(tutorProfile.uid)),
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
  Future<bool> updateTuteeAssignment(
      {TuteeAssignmentEntity tuteeParams}) async {
    // TODO(ElasticBottle): update Tutee assignment
    final DocumentReference userRef =
        store.document(FirestorePath.users(tuteeParams.uid));
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot userSnapshot = await tx.get(userRef);
        final String postId = Uuid().v1();
        final Map<String, dynamic> toAdd = tuteeParams.toDocumentSnapshot()[1];
        toAdd.addAll(<String, dynamic>{
          DATE_ADDED: FieldValue.serverTimestamp(),
          NUM_APPLIED: 0,
          NUM_LIKED: 0,
        });
        userSnapshot.data[USER_ASSIGNMENTS]
            .addAll(<String, Map<String, dynamic>>{postId: toAdd});
        tx.update(
            store.document(FirestorePath.users(tuteeParams.uid)),
            <String, Map<String, dynamic>>{
              USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
            });
        tx.set(store.document(FirestorePath.assignment(postId)), toAdd);
        // TODO(ElasticBottle): Change toAdd here take a Map<uid, photoURL> under liked key
        tx.set(store.document(FirestorePath.likeAssignment(postId)), toAdd);
      });
      return true;
    } catch (e) {
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
          final DocumentSnapshot profileLikeSnapshot = await tx.get(
              store.document(FirestorePath.likeProfiles(tutorProfile.uid)));
          final Map<String, dynamic> toAdd =
              tutorProfile.toDocumentSnapshot()[1];
          // print(profileSnapshot.data[NUM_REQUEST]);
          toAdd.addAll(<String, dynamic>{
            UID: tutorProfile.uid,
            DATE_ADDED: profileSnapshot.data[DATE_ADDED],
            DATE_MODIFIED: FieldValue.serverTimestamp(),
            NUM_REQUEST: profileSnapshot.data[NUM_REQUEST],
            NUM_LIKED: profileSnapshot.data[NUM_LIKED],
            NUM_CLICKS: profileSnapshot.data[NUM_CLICKS],
            RATING: profileSnapshot.data[RATING],
          });

          tx.update(
            store.document(FirestorePath.users(tutorProfile.uid)),
            <String, Map<String, dynamic>>{TUTOR_PROFILE: toAdd},
          );
          tx.update(
            tutorProfileRef,
            toAdd,
          );

          toAdd.addAll(profileLikeSnapshot.data[LIKED]);
          tx.update(
            store.document(FirestorePath.likeProfiles(tutorProfile.uid)),
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
  }) {
    // TODO(ElasticeBottle): implement requestTutor
    throw UnimplementedError();
  }
}
