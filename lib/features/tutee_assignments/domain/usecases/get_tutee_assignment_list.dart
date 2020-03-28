import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class GetTuteeAssignmentList extends UseCase<List<TuteeAssignment>, NoParams> {
  GetTuteeAssignmentList({this.repo});
  TuteeAssignmentRepo repo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> call(NoParams params) async {
    final result = await repo.getAssignmentList();
    return result;
  }
}
