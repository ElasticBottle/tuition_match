import 'dart:async';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

// @immutable
// class User {
//   const User({
//     @required this.uid,
//     this.email,
//     this.isEmailVerified,
//     this.photoUrl,
//     this.displayName,
//   });

//   final String uid;
//   final String email;
//   final bool isEmailVerified;
//   final String photoUrl;
//   final String displayName;
// }

abstract class AuthServiceRepo {
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, bool>> isUserEmailVerified();
  Future<Either<Failure, void>> sendEmailVerification();
  Future<void> sendPasswordResetEmail(String email);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithFacebook();
  Future<Either<Failure, void>> signOut();
  Stream<User> get onAuthStateChanged;

  Future<Either<Failure, bool>> isUsernameValid(String username);
  Future<Either<Failure, bool>> createAccountWithEmail(
      {String email,
      String password,
      String username,
      String firstName,
      String lastName});
  void dispose();
}
