import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutee_criteria_params.dart';
import 'package:dartz/dartz.dart';

abstract class TuteeAssignmentRepo {
  // Retrieving Assignment List
  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList();
  Future<Either<Failure, List<TuteeAssignment>>> getNextAssignmentList();
  Future<Either<Failure, List<TuteeAssignment>>> getCachedAssignmentList();

  // Retrieving Searched List
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion(
      TuteeCriteriaParams params);
  Future<Either<Failure, List<TuteeAssignment>>> getByCachedCriterion();
  Future<Either<Failure, List<TuteeAssignment>>> getNextCriterionList();

  // Setting new Assignment
  Future<Either<Failure, TuteeAssignment>> getCachedTuteeAssignmentToSet();
  Future<Either<Failure, bool>> setTuteeAssignment(TuteeAssignment assignment);
  Future<Either<Failure, bool>> updateTuteeAssignment(
      TuteeAssignment assignment);

  // Deleting Assignment
  Future<Either<Failure, bool>> delAssignment({String uid, String postId});
}
