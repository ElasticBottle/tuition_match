import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class GetCachedTuteeAssignmentToSet extends UseCase<TuteeAssignment, NoParams> {
  GetCachedTuteeAssignmentToSet({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, TuteeAssignment>> call(NoParams params) async {
    final Either<Failure, TuteeAssignment> params =
        await repo.getCachedTuteeAssignmentToSet();
    return params;
  }
}
