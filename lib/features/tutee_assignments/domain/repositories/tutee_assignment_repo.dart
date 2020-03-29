import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:dartz/dartz.dart';

abstract class TuteeAssignmentRepo {
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion({
    Level level,
    Subject subject,
    double rateMin,
    double rateMax,
  });

  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList();
}
