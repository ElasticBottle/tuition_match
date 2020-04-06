import 'package:cotor/core/error/failures.dart';
import 'package:cotor/data/models/criteria_params.dart';
import 'package:cotor/data/models/del_params.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:dartz/dartz.dart';

abstract class TutorProfileRepo {
  // Retrieving Assignment List
  Future<Either<Failure, List<TutorProfile>>> getProfileList();
  Future<Either<Failure, List<TutorProfile>>> getNextProfileList();
  Future<Either<Failure, List<TutorProfile>>> getCachedProfileList();

  // Retrieving Searched List
  Future<Either<Failure, List<TutorProfile>>> getByCriterion(
      CriteriaParams params);
  Future<Either<Failure, List<TutorProfile>>> getByCachedCriterion();
  Future<Either<Failure, List<TutorProfile>>> getNextCriterionList();

  // Setting new Assignment
  Future<Either<Failure, TutorProfileModel>> getCachedTuteeAssignmentToSet();
  Future<Either<Failure, bool>> setTuteeAssignment(TuteeAssignmentModel params);
  Future<Either<Failure, bool>> updateTuteeAssignment(
      TuteeAssignmentModel params);

  // Deleting Assignment
  Future<Either<Failure, bool>> delAssignment(DelParams params);
}
