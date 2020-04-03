import 'package:cotor/core/error/failures.dart';
import 'package:cotor/data/models/criteria_params.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/usecases/tutee_assignments/del_tutee_assignment.dart';
import 'package:dartz/dartz.dart';

abstract class TuteeAssignmentRepo {
  // Retrieving Assignment List
  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList();

  Future<Either<Failure, List<TuteeAssignment>>> getNextAssignmentList();

  Future<Either<Failure, List<TuteeAssignment>>> getCachedAssignmentList();

  // Retrieving Searched List
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion(
      CriteriaParams params);

  Future<Either<Failure, List<TuteeAssignment>>> getByCachedCriterion();

  Future<Either<Failure, List<TuteeAssignment>>> getNextCriterionList();

  // Setting new Assignment
  Future<Either<Failure, TuteeAssignmentModel>> getCachedTuteeAssignmentToSet();

  Future<Either<Failure, bool>> setTuteeAssignment(TuteeAssignmentModel params);

  Future<Either<Failure, bool>> updateTuteeAssignment(
      TuteeAssignmentModel params);

  // Deleting Assignment
  Future<Either<Failure, bool>> delAssignment(DelParams params);
}
