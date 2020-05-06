import 'dart:async';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:dartz/dartz.dart';

/// A repository for handling everything related to verifying and authenticating user
///
/// Cases which should be handled by this repo:
/// * Signing up
/// * Logging in
/// * Logging out
/// * Verifying the state of users account
/// * Allowing users to change things related to Auth (password, email etc.)
/// * Providing details regarding anything authentication related
abstract class AuthServiceRepo {
  /// Returns a [Stream<User>] listening to the Auth state
  ///
  /// Triggers everytime a user logs in or out
  Stream<User> userStream();

  /// Returns a [User] base on the Auth state
  ///
  /// Throws either:
  /// * __[NoUserFailure]__ when there is no currently logged in user
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, User>> getCurrentLoggedInUser();

//  ___ _             _   _
// / __(_)__ _ _ _   | | | |_ __
// \__ \ / _` | ' \  | |_| | '_ \
// |___/_\__, |_||_|  \___/| .__/
//       |___/             |_|

  /// Creates a user account and corresponding userDocument in database
  ///
  /// All fields should be provided
  ///
  /// Returns [true] on successful account creation
  ///
  /// Failure is one of:
  /// * __[NetworkFailure]__ when called without internet access on user's device
  /// * __[AuthicationFailure]__ when there was an error creating an account for the user
  /// * __[ServerFailure]__ when there was error creating user documents
  Future<Either<Failure, bool>> createAccountWithEmail({
    String email,
    String password,
    String phoneNum,
    String firstName,
    String lastName,
  });

  /// Sends an email to user for verification
  ///
  /// Returns Either:
  /// * __[true]__ if successful.
  /// * __[AuthenticationFailure]__ if unsuccessful
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> sendEmailVerification();

  /// Retrieves the state of user email validity
  ///
  /// Returns Either:
  /// * __[bool]__ indicating user's email verification state.
  /// * __[AuthenticationFailure]__ if error while executing task
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> isUserEmailVerified();

  /// Sends an email to user for ressetting their password
  ///
  /// Returns Either:
  /// * __[true]__ if successful.
  /// * __[AuthenticationFailure]__ if error while executing task
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> sendPasswordResetEmail(String email);

//  ___ _             ___
// / __(_)__ _ _ _   |_ _|_ _
// \__ \ / _` | ' \   | || ' \
// |___/_\__, |_||_| |___|_||_|
//       |___/

  /// Signs user in based on their email and password
  ///
  /// Returns Either:
  /// * __[User]__ if user signs in successfully.
  /// * __[AuthenticationFailure]__ if error while executing task
  ///   * includes failure to login user with given credentials for whatever reason
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password);

  /// Signs user in with their google acocunt
  ///
  /// Returns Either:
  /// * __[User]__ if user signs in successfully.
  /// * __[AuthenticationFailure]__ if error while executing task
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, User>> signInWithGoogle();

  /// Signs user out
  ///
  /// Returns Either:
  /// * __[AuthenticationFailure]__ if error while executing task
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, void>> signOut();
  // Future<Either<Failure, User>> signInWithFacebook();

}
