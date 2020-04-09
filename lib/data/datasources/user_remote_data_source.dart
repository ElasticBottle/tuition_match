import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/datasources/firestore_path.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/user_model.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRemoteDataSource {
  Future<User> getCurrentUser();
  Future<User> getUserInfo(String username);
  Future<PrivateUserInfo> getUserPrivateInfo(String username);
  Future<void> createNewUserDocument({
    String username,
    String firstname,
    String lastname,
  });
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
}
