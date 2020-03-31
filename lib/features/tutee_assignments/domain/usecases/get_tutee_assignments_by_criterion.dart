import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/data/models/criteria_params.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class GetTuteeAssignmentsByCriterion
    extends UseCase<List<TuteeAssignment>, CriteriaParams> {
  GetTuteeAssignmentsByCriterion({this.repo});

  TuteeAssignmentRepo repo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> call(params) async {
    final Either<Failure, List<TuteeAssignment>> result =
        await repo.getByCriterion(params);
    return result;
  }
}
