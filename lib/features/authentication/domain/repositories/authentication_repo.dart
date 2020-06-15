import 'dart:async';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
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
abstract class AuthenticationRepo {
  /// Returns a [Stream<User>] listening to the Auth state
  ///
  /// Triggers everytime a user logs in or out
  Stream<AuthenticatedUser> userStream();

  /// Returns a [AuthenticatedUser] base on the Auth state
  ///
  /// Throws either:
  /// * __[NoUserFailure]__ when there is no currently logged in user
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, AuthenticatedUser>> getCurrentLoggedInUser();

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
  /// * __[AuthenticationFailure]__ when there was an error creating an account for the user
  Future<Either<Failure, AuthenticatedUser>> createAccountWithEmail({
    String email,
    String password,
  });

  /// Creates a new user document
  ///
  /// Returns Either:
  /// * __[true]__ upon successful creation
  /// * __[ServerFailure]__ when there are errors creating documents
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> createNewUserDocument({
    String uid,
    String photoUrl,
    String firstName,
    String lastName,
    String countryCode,
    String phoneNum,
  });

  /// Sends an email to user for verification
  ///
  /// Returns Either:
  /// * __[true]__ if successful.
  /// * __[SendEmailFailure]__ if unsuccessful
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
  /// * __[AuthenticatedUser]__ if user signs in successfully.
  /// * __[AuthenticationFailure]__ if error while executing task
  ///   * includes failure to login user with given credentials for whatever reason
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, AuthenticatedUser>> signInWithEmailAndPassword(
      String email, String password);

  /// Checks if user has an existing document created in Firebase
  ///
  /// Returns Either:
  /// * __[bool]__ indicating the existence of the user document in cloud.
  /// * __[ServerFailure]__ when unable to communicate with server
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> isUserProfileCreated(String uid);

  /// Signs user in with their google acocunt
  ///
  /// Returns Either:
  /// * __[AuthenticatedUser]__ if user signs in successfully.
  /// * __[AuthenticationFailure]__ if error while executing task
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, AuthenticatedUser>> signInWithGoogle();

  /// Signs user out
  ///
  /// Returns Either:
  /// * nothing if successful
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, void>> signOut();
  // Future<Either<Failure, User>> signInWithFacebook();

}
