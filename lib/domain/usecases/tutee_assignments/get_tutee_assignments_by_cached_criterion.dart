import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class GetTuteeAssignmentsByCachedCriterion
    extends UseCase<List<TuteeAssignment>, NoParams> {
  GetTuteeAssignmentsByCachedCriterion({this.repo});

  TuteeAssignmentRepo repo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> call(NoParams params) async {
    final Either<Failure, List<TuteeAssignment>> result =
        await repo.getByCachedCriterion();
    return result;
  }
}
