import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/datasources/firestore_path.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:cotor/data/models/tutor_profile_model.dart';
import 'package:cotor/data/models/user_model.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

abstract class UserRemoteDataSource {
  Future<User> getCurrentUser();
  Future<User> getUserInfo(String username);
  Future<PrivateUserInfo> getUserPrivateInfo(String username);
  Future<void> createNewUserDocument({
    String username,
    String firstname,
    String lastname,
  });

  Future<bool> delAssignment({String postId, String username});
  Future<bool> setTuteeAssignment({TuteeAssignmentModel tuteeParams});
  Future<bool> updateTuteeAssignment({TuteeAssignmentModel tuteeParams});

  Future<bool> delProfile({String username});
  Future<bool> setTutorProfile({TutorProfileModel tutorParams});
  Future<bool> updateTutorProfile({TutorProfileModel tutorParams});
}

class FirestoreUserDataSource implements UserRemoteDataSource {
  FirestoreUserDataSource({this.store, this.auth});
  final Firestore store;
  final FirebaseAuth auth;

  @override
  Future<User> getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    if (user == null) {
      throw NoUserException();
    }
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<void> createNewUserDocument({
    String username,
    String firstname,
    String lastname,
  }) async {
    final DocumentReference ref = store.document(FirestorePath.users(username));
    try {
      return await ref.setData(<String, dynamic>{
        FIRSTNAME: firstname,
        LASTNAME: lastname,
      });
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<User> getUserInfo(String username) async {
    final DocumentReference ref = store.document(FirestorePath.users(username));
    try {
      final DocumentSnapshot result = await ref.get();
      if (result == null) {
        throw NoUserException();
      } else {
        return UserModel.fromDocumentSnapshot(result);
      }
    } catch (e) {
      throw ServerException();
    }
    // Firestore.instance
    // .collection("users")
    // .document(currentUser.uid)
    // .get()
  }

  @override
  Future<PrivateUserInfo> getUserPrivateInfo(String username) {
    // TODO: implement getUserPrivateInfo
    throw UnimplementedError();
  }

  @override
  Future<bool> delAssignment({String postId, String username}) async {
    final DocumentReference userRef =
        store.document(FirestorePath.users(username));
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
  Future<bool> delProfile({String username}) async {
    try {
      await store.runTransaction((Transaction tx) async {
        tx.update(store.document(FirestorePath.users(username)),
            <String, dynamic>{PROFILE: '', IS_TUTOR: false});
        tx.delete(store.document(FirestorePath.tutorProfile(username)));
        tx.delete(store.document(FirestorePath.likeProfiles(username)));
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
        store.document(FirestorePath.users(tuteeParams.username));
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot userSnapshot = await tx.get(userRef);
        final String postId = Uuid().v1();
        final Map<String, dynamic> toAdd = tuteeParams.toDocumentSnapshot()[1];
        toAdd.addAll(<String, dynamic>{
          DATE_ADDED: FieldValue.serverTimestamp(),
          STATUS: 0,
          APPLIED: 0,
          LIKED: 0,
        });
        userSnapshot.data[USER_ASSIGNMENTS]
            .addAll(<String, Map<String, dynamic>>{postId: toAdd});
        tx.update(
            store.document(FirestorePath.users(tuteeParams.username)),
            <String, Map<String, dynamic>>{
              USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
            });
        tx.set(store.document(FirestorePath.assignment(postId)), toAdd);
        // TODO(ElasticBottle): Change toAdd here take a Map<username, photoURL> under liked key
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
    // try {
    //   await store.runTransaction((Transaction tx) async {
    //     final Map<String, dynamic> toAdd = tutorParams.toDocumentSnapshot()[1];
    //     toAdd.addAll(<String, dynamic>{
    //       DATE_ADDED: FieldValue.serverTimestamp(),
    //       DATE_MODIFIED: FieldValue.serverTimestamp(),
    //       STATUS: 0,
    //       REQUEST: 0,
    //       LIKED: 0,
    //       RATING: 0.0,
    //     });
    //     tx.update(store.document(FirestorePath.users(tutorParams.username)),
    //         <String, Map<String, dynamic>>{PROFILE: toAdd});
    //     tx.set(store.document(FirestorePath.tutorProfile(tutorParams.username)),
    //         toAdd);
    // TODO(ElasticBottle): Change toAdd here take a Map<username, photoURL> under liked key
    //     tx.set(store.document(FirestorePath.likeProfiles(tutorParams.username)),
    //         toAdd);
    //   });
    //   return true;
    // } catch (e) {
    //   print(e.toString());
    //   throw ServerException();
    // }
    final Map<String, dynamic> toAdd = tutorParams.toDocumentSnapshot()[1];
    toAdd.addAll(<String, dynamic>{
      DATE_ADDED: FieldValue.serverTimestamp(),
      DATE_MODIFIED: FieldValue.serverTimestamp(),
      STATUS: 0,
      REQUEST: 0,
      LIKED: 0,
      RATING: 0.0,
    });
    final WriteBatch batch = store.batch();
    batch.updateData(store.document(FirestorePath.users(tutorParams.username)),
        <String, Map<String, dynamic>>{PROFILE: toAdd});
    batch.setData(
        store.document(FirestorePath.tutorProfile(tutorParams.username)),
        toAdd);
    // TODO(ElasticBottle): Change toAdd here take a Map<username, photoURL> under liked key
    batch.setData(
        store.document(FirestorePath.likeProfiles(tutorParams.username)),
        toAdd);
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
        store.document(FirestorePath.users(tuteeParams.username));
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot userSnapshot = await tx.get(userRef);
        final String postId = Uuid().v1();
        final Map<String, dynamic> toAdd = tuteeParams.toDocumentSnapshot()[1];
        toAdd.addAll(<String, dynamic>{
          DATE_ADDED: FieldValue.serverTimestamp(),
          STATUS: 0,
          APPLIED: 0,
          LIKED: 0,
        });
        userSnapshot.data[USER_ASSIGNMENTS]
            .addAll(<String, Map<String, dynamic>>{postId: toAdd});
        tx.update(
            store.document(FirestorePath.users(tuteeParams.username)),
            <String, Map<String, dynamic>>{
              USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
            });
        tx.set(store.document(FirestorePath.assignment(postId)), toAdd);
        // TODO(ElasticBottle): Change toAdd here take a Map<username, photoURL> under liked key
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
    // TODO(ElasticBottle): update Tutee assignment
    final DocumentReference userRef =
        store.document(FirestorePath.users(tutorParams.username));
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot userSnapshot = await tx.get(userRef);
        final String postId = Uuid().v1();
        final Map<String, dynamic> toAdd = tutorParams.toDocumentSnapshot()[1];
        toAdd.addAll(<String, dynamic>{
          DATE_ADDED: FieldValue.serverTimestamp(),
          STATUS: 0,
          APPLIED: 0,
          LIKED: 0,
        });
        userSnapshot.data[USER_ASSIGNMENTS]
            .addAll(<String, Map<String, dynamic>>{postId: toAdd});
        tx.update(
            store.document(FirestorePath.users(tutorParams.username)),
            <String, Map<String, dynamic>>{
              USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
            });
        tx.set(store.document(FirestorePath.assignment(postId)), toAdd);
        // TODO(ElasticBottle): Change toAdd here take a Map<username, photoURL> under liked key
        tx.set(store.document(FirestorePath.likeAssignment(postId)), toAdd);
      });
      return true;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }
}
