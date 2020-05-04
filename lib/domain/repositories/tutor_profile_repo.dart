import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutor_criteria_params.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:dartz/dartz.dart';

/// A repository for retrieving and displaying data relating to allowing users to find Profiles
///
/// Things that are to be included:
/// * Retrieving Profiles
/// * Retriving pre-fetched Profiles
/// * Retrieivng Profiles based on various criterions
/// * Retrieving profiles based on user's preference
/// * Retrieving specific profiles
abstract class TutorProfileRepo {
  // Retrieving Profile List

  /// Gets the latest list from database
  ///
  /// Returns Either:
  /// * __[List<TutorProfile>]__ on successful retrieval.
  /// [List<TutorProfile>] can be empty if there is no items in databsae
  /// * __[ServerFailure]__ when there was error retrieving [List<TutorProfile>]
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, List<TutorProfile>>> getProfileList();

  /// Gets the Next list from database where [getProfileList()] left off
  ///
  /// To be called only after calling [getProfileList()] at least once
  /// Returns Either:
  /// * __[List<TutorProfile>]__ on successful retrieval.
  /// [List<TutorProfile>] can be empty if there is no futther items
  /// * __[ServerFailure]__ when there was error retrieving [List<TutorProfile>]
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, List<TutorProfile>>> getNextProfileList();

  /// Gets a cached list from device's local storage
  ///
  /// Returns Either:
  /// * __[List<TutorProfile>]__ on successful retrieval of a pre-existing [List<TutorProfile>]
  /// * __[CacheFailure]__ if there was no previously cached [List<TutorProfile>]
  Future<Either<Failure, List<TutorProfile>>> getCachedProfileList();

  // Retrieving Searched List

  /// `NOT PROPERLY IMPLEMENTED YET`
  /// Retrieves a filtered [List<TutorProfile>]
  ///
  /// Returns Either:
  /// * __[List<TutorProfile>]__ on successful retrieval of a filtered [List<TutorProfile>].
  /// [List<TutorProfile>] can be empty if there is no items
  /// * __[ServerFailure]__ when there was error retrieving [List<TutorProfile>]
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, List<TutorProfile>>> getByCriterion(
      TutorCriteriaParams params);

  /// `NOT PROPERLY IMPLEMENTED YET`
  /// Gets the Next list from database where [getByCriterion(params)] left off
  ///
  /// To be called only after calling [getByCriterion(params)] at least once
  /// Returns Either:
  /// * __[List<TutorProfile>]__ on successful retrieval.
  /// [List<TutorProfile>] can be empty if there is no futther items
  /// * __[ServerFailure]__ when there was error retrieving [List<TutorProfile>]
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, List<TutorProfile>>> getByCachedCriterion();

  /// `NOT PROPERLY IMPLEMENTED YET`
  Future<Either<Failure, List<TutorProfile>>> getNextCriterionList();
}
