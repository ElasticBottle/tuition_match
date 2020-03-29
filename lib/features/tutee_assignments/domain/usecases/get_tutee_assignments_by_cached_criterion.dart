import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/get_tutee_assignments_by_criterion.dart';
import 'package:dartz/dartz.dart';

class GetTuteeAssignmentsByCachedCriterion
    extends UseCase<List<TuteeAssignment>, Params> {
  GetTuteeAssignmentsByCachedCriterion({this.repo});

  TuteeAssignmentRepo repo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> call(params) async {
    final Either<Failure, List<TuteeAssignment>> result =
        await repo.getByCachedCriterion(
      level: params.level,
      subject: params.subject,
      rateMin: params.rateMin,
      rateMax: params.rateMax,
    );
    return result;
  }
}
