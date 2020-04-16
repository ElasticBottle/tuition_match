import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/datasources/firestore_path.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:cotor/data/models/tutor_profile_model.dart';
import 'package:cotor/data/models/user_model.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

abstract class UserRemoteDataSource {
  Stream<User> get userStream;
  Stream<User> userProfileStream(String uid);

  Future<User> getCurrentUser();
  Future<User> getUserInfo(String uid);
  Future<PrivateUserInfo> getUserPrivateInfo(String uid);
  Future<void> createNewUserDocument({
    String firstname,
    String lastname,
    String phoneNum,
  });

  Future<bool> delAssignment({String postId, String uid});
  Future<bool> setTuteeAssignment({TuteeAssignmentModel tuteeParams});
  Future<bool> updateTuteeAssignment({TuteeAssignmentModel tuteeParams});

  Future<bool> delProfile({String uid});
  Future<bool> setTutorProfile({TutorProfileModel tutorParams});
  Future<bool> updateTutorProfile({TutorProfileModel tutorParams});
}

class FirestoreUserDataSource implements UserRemoteDataSource {
  FirestoreUserDataSource({this.store, this.auth});
  final Firestore store;
  final FirebaseAuth auth;

  @override
  Stream<User> get userStream {
    return auth.onAuthStateChanged
        .map((event) => UserModel.fromFirebaseUser(event));
  }

  @override
  Stream<User> userProfileStream(String uid) {
    return store.document(FirestorePath.users(uid)).snapshots().map(
        (DocumentSnapshot userProfileDoc) =>
            UserModel.fromDocumentSnapshot(userProfileDoc));
  }

  @override
  Future<User> getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    if (user == null) {
      throw NoUserException();
    }
    user.reload();
    final FirebaseUser newUser = await auth.currentUser();
    return UserModel.fromFirebaseUser(newUser);
  }

  @override
  Future<void> createNewUserDocument({
    @required String firstname,
    @required String lastname,
    @required String phoneNum,
  }) async {
    final User user = await getCurrentUser();
    final DocumentReference ref = store.document(FirestorePath.users(user.uid));
    try {
      await ref.setData(<String, dynamic>{
        NAME: <String, String>{
          FIRSTNAME: firstname,
          LASTNAME: lastname,
        },
        PHOTOURL: '',
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
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<User> getUserInfo(String uid) async {
    final DocumentReference ref = store.document(FirestorePath.users(uid));
    try {
      final DocumentSnapshot result = await ref.get();
      if (result.data == null) {
        throw NoUserException();
      } else {
        return UserModel.fromDocumentSnapshot(result);
      }
    } catch (e) {
      print(e.toString());
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
  Future<bool> setTuteeAssignment({TuteeAssignmentModel tuteeParams}) async {
    final DocumentReference userRef =
        store.document(FirestorePath.users(tuteeParams.uid));
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot userSnapshot = await tx.get(userRef);
        final String postId = Uuid().v1();
        final Map<String, dynamic> toAdd = tuteeParams.toDocumentSnapshot()[1];
        toAdd.addAll(<String, dynamic>{
          DATE_ADDED: FieldValue.serverTimestamp(),
          STATUS: 0,
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
  Future<bool> setTutorProfile({TutorProfileModel tutorParams}) async {
    final Map<String, dynamic> toAdd = tutorParams.toDocumentSnapshot()[1];
    toAdd.addAll(<String, dynamic>{
      DATE_ADDED: FieldValue.serverTimestamp(),
      DATE_MODIFIED: FieldValue.serverTimestamp(),
      NUM_REQUEST: 0,
      NUM_LIKED: 0,
      RATING: 0.0,
    });
    final WriteBatch batch = store.batch();
    batch.updateData(
      store.document(FirestorePath.users(tutorParams.uid)),
      <String, Map<String, dynamic>>{TUTOR_PROFILE: toAdd},
    );
    batch.setData(
      store.document(FirestorePath.tutorProfile(tutorParams.uid)),
      toAdd,
    );
    toAdd.addAll(<String, Map<String, String>>{LIKED: <String, String>{}});
    batch.setData(
      store.document(FirestorePath.likeProfiles(tutorParams.uid)),
      toAdd,
    );
    try {
      await batch.commit();
      return true;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> updateTuteeAssignment({TuteeAssignmentModel tuteeParams}) async {
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
          STATUS: 0,
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
  Future<bool> updateTutorProfile({TutorProfileModel tutorParams}) async {
    final DocumentReference tutorProfileRef =
        store.document(FirestorePath.tutorProfile(tutorParams.uid));
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot profileSnapshot = await tx.get(tutorProfileRef);
        final Map<String, dynamic> toAdd = tutorParams.toDocumentSnapshot()[1];
        toAdd.addAll(<String, dynamic>{
          DATE_MODIFIED: FieldValue.serverTimestamp(),
          NUM_REQUEST: profileSnapshot.data[NUM_REQUEST],
          NUM_LIKED: profileSnapshot.data[NUM_LIKED],
          RATING: profileSnapshot.data[RATING],
        });

        tx.update(
          store.document(FirestorePath.users(tutorParams.uid)),
          <String, Map<String, dynamic>>{TUTOR_PROFILE: toAdd},
        );
        tx.update(
          store.document(FirestorePath.assignment(tutorParams.uid)),
          toAdd,
        );
        final DocumentSnapshot profileLikeSnapshot = await tx
            .get(store.document(FirestorePath.likeProfiles(tutorParams.uid)));
        toAdd.addAll(profileLikeSnapshot.data[LIKED]);
        tx.set(
          store.document(FirestorePath.likeProfiles(tutorParams.uid)),
          toAdd,
        );
      });
      return true;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }
}
