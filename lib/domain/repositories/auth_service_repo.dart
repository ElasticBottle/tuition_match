import 'dart:async';

import 'package:cotor/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.isEmailVerified,
    this.photoUrl,
    this.displayName,
  });

  final String uid;
  final String email;
  final bool isEmailVerified;
  final String photoUrl;
  final String displayName;
}

abstract class AuthServiceRepo {
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, User>> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithFacebook();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> sendEmailverification();
  Stream<User> get onAuthStateChanged;
  void dispose();
}
