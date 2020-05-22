import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/applications/application.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/entities/user/withheld_info.dart';
import 'package:dartz/dartz.dart';

/// A repository for all the things that users can do within the app
///
/// Cases of things that should be handled by this repository:
/// * Providing realtime user details
/// * Allowing user to set, update, and retrived their profile
/// * Allowing user to set, update, and retrieved their assigments
/// * Allowing user to change things relating to their profile
/// * Allowing users to hanlde core business functions (accepting and rejecting students // tutors)
abstract class UserRepo {
//   ___                       _                      _       __
//  / __|___ _ _  ___ _ _ __ _| |  _  _ ___ ___ _ _  (_)_ _  / _|___
// | (_ / -_) ' \/ -_) '_/ _` | | | || (_-</ -_) '_| | | ' \|  _/ _ \
//  \___\___|_||_\___|_| \__,_|_|  \_,_/__/\___|_|   |_|_||_|_| \___/
//

  /// Gets [User] as a stream
  ///
  /// Returns a [Stream<User>] listening to the user public info
  ///
  /// Trigger everytime the currently logged-in user updates their profile
  /// This includes changes to user's [TutorProfile] and [TuteeAssignment]
  ///
  /// This _does not include_ changes to user's [RequestedTutors], [AppliedAssignments], and [Likes] (yet).
  Stream<User> userProfileStream(String uid);

  /// Gets [User] for the currently Logged-in user.
  ///
  /// Returns Either:
  ///  * __[User]__ upon successful retrieval of user info
  /// * __[NoUserFailure]__ when document for [uid] does not exist
  /// * __[ServerFailure]__ when there was error retrieving the doc
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, User>> getUserInfo(String uid);

  /// gets the private info of the user
  ///
  /// Returns Either:
  /// * __[WithheldInfo]__ upon successful retrieval
  /// * __[ServerFailure]__ when there are errors retrieving document
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, WithheldInfo>> getUserContactInfo(String uid);

  /// Creates a new user document
  ///
  /// Returns Either:
  /// * __[true]__ upon successful creation
  /// * __[ServerFailure]__ when there are errors creating documents
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> createNewUserDocument({
    String uid,
    String photoUrl,
    String firstname,
    String lastname,
    String countryCode,
    String phoneNum,
  });

//  ___ _        _
// / __| |_ __ _| |_ _  _ ___
// \__ \  _/ _` |  _| || (_-<
// |___/\__\__,_|\__|\_,_/__/

//  ___                      _
// | _ \___ __ _ _  _ ___ __| |_ ___
// |   / -_) _` | || / -_|_-<  _(_-<
// |_|_\___\__, |\_,_\___/__/\__/__/
//            |_|

  /// Adds a assignment to requested tutor while updating user's own request records
  ///
  /// Returns Either:
  /// * __[true]__ upon successful request
  /// * __[ServerFailure]__ when there are errors processing the request
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> setApplication({
    Application application,
    bool isNewApp,
    bool toSave,
  });

  /// Gets [Application] as a stream
  ///
  /// Returns a [Stream<Application>] listening to a particular post
  ///
  /// Triggers everytime there is a new application for a particular post
  Stream<List<Application>> requestStream({String id, bool isProfile});

//  _   _                 _          _                         _
// | | | |___ ___ _ _    /_\   _____(_)__ _ _ _  _ __  ___ _ _| |_
// | |_| (_-</ -_) '_|  / _ \ (_-<_-< / _` | ' \| '  \/ -_) ' \  _|
//  \___//__/\___|_|   /_/ \_\/__/__/_\__, |_||_|_|_|_\___|_||_\__|
//                                    |___/

// TODO(ElasticBottle): Actually think about the implementation
  Future<Either<Failure, TuteeAssignment>> getCachedTuteeAssignmentToSet();

  /// Creates new user assignment
  ///
  /// Returns Either:
  /// * __[true]__ upon successful creation
  /// * __[ServerFailure]__ when there are errors processing the request
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, String>> setTuteeAssignment(
      TuteeAssignment assignment);

  /// Updates specified user assignment
  ///
  /// Returns Either:
  /// * __[true]__ upon successful update
  /// * __[ServerFailure]__ when there are errors processing the request
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, String>> updateTuteeAssignment(
      TuteeAssignment assignment);

  /// Deletes specified user assignment
  ///
  /// Returns Either:
  /// * __[true]__ upon successful deletion
  /// * __[ServerFailure]__ when there are errors processing the request
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> delAssignment({String uid, String postId});

//  _   _               ___          __ _ _
// | | | |___ ___ _ _  | _ \_ _ ___ / _(_) |___
// | |_| (_-</ -_) '_| |  _/ '_/ _ \  _| | / -_)
//  \___//__/\___|_|   |_| |_| \___/_| |_|_\___|

  /// Cache [TutorProfile] for future retrieval
  Future<Either<Failure, void>> cacheTutorProfileToSet(TutorProfile profile);

  /// Retrieves caches [TutorProfile]
  ///
  /// Returns Either:
  /// * __[TutorProfile]__ upon successful retrieval
  /// * __[CacheFailure]__ when there is an error.
  Future<Either<Failure, TutorProfile>> getCachedTutorProfileToSet();

  /// Creates new User Profile
  ///
  /// Returns Either:
  /// * __[true]__ upon successful deletion
  /// * __[ServerFailure]__ when there are errors processing the request
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> setTutorProfile(TutorProfile profile);

  /// Updates User Profile
  ///
  /// Returns Either:
  /// * __[true]__ upon successful deletion
  /// * __[ServerFailure]__ when there are errors processing the request
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> updateTutorProfile(TutorProfile profile);

  /// Deletes specified user Profile
  ///
  /// Returns Either:
  /// * __[true]__ upon successful deletion
  /// * __[ServerFailure]__ when there are errors processing the request
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> delProfile(String uid);
}
