import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:dartz/dartz.dart';

abstract class TuteeAssignmentRepo {
  // Retrieving Assignment List
  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList();

  Future<Either<Failure, List<TuteeAssignment>>> getNextAssignmentList();

  Future<Either<Failure, List<TuteeAssignment>>> getCachedAssignmentList();

  // Retrieving Searched List
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion({
    Level level,
    Subject subject,
    double rateMin,
    double rateMax,
  });

  Future<Either<Failure, List<TuteeAssignment>>> getByCachedCriterion();

  Future<Either<Failure, List<TuteeAssignment>>> getNextCriterionList();

  // Setting new Assignment

  // Deleting Assignment
}
