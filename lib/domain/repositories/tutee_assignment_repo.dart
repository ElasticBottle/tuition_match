import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutee_criteria_params.dart';
import 'package:dartz/dartz.dart';

/// A repository for retrieving and displaying data relating to allowing users to find assignments
///
/// Things that are to be included:
/// * Retrieving assignments
/// * Retriving pre-fetched assignments
/// * Retrieivng assignments based on various criterions
/// * Retrieving assingments based on user's preference
/// * Retrieving specific assignments
abstract class TuteeAssignmentRepo {
  // Retrieving Assignment List

  /// Gets the latest list from database
  ///
  /// Returns Either:
  /// * __[List<TuteeAssignment>]__ on successful retrieval.
  /// [List<TuteeAssignment>] can be empty if there is no items in databsae
  /// * __[ServerFailure]__ when there was error retrieving [List<TuteeAsisgnment>]
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList();

  /// Gets the Next list from database where [getAssignmentList()] left off
  ///
  /// To be called only after calling [getAssignmentList()] at least once
  /// Returns Either:
  /// * __[List<TuteeAssignment>]__ on successful retrieval.
  /// [List<TuteeAssignment>] can be empty if there is no futther items
  /// * __[ServerFailure]__ when there was error retrieving [List<TuteeAsisgnment>]
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, List<TuteeAssignment>>> getNextAssignmentList();

  /// Gets a cached list from device's local storage
  ///
  /// Returns Either:
  /// * __[List<TuteeAssignment>]__ on successful retrieval of a pre-existing [List<TuteeAssignment>]
  /// * __[CacheFailure]__ if there was no previously cached [List<TuteeAsisgnment>]
  Future<Either<Failure, List<TuteeAssignment>>> getCachedAssignmentList();

  // Retrieving searched List

  /// `NOT PROPERLY IMPLEMENTED YET`
  /// Retrieves a filtered [List<TuteeAssignment>]
  ///
  /// Returns Either:
  /// * __[List<TuteeAssignment>]__ on successful retrieval of a filtered [List<TuteeAssignment>].
  /// [List<TuteeAssignment>] can be empty if there is no items
  /// * __[ServerFailure]__ when there was error retrieving [List<TuteeAsisgnment>]
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion(
      TuteeCriteriaParams params);

  /// `NOT PROPERLY IMPLEMENTED YET`
  /// Gets the Next list from database where [getByCriterion(params)] left off
  ///
  /// To be called only after calling [getByCriterion(params)] at least once
  /// Returns Either:
  /// * __[List<TuteeAssignment>]__ on successful retrieval.
  /// [List<TuteeAssignment>] can be empty if there is no futther items
  /// * __[ServerFailure]__ when there was error retrieving [List<TuteeAsisgnment>]
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, List<TuteeAssignment>>> getNextCriterionList();

  /// `NOT PROPERLY IMPLEMENTED YET`
  Future<Either<Failure, List<TuteeAssignment>>> getByCachedCriterion();
}
