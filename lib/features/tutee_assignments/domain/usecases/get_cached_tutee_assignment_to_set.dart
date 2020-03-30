import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/set_tutee_assignment.dart';
import 'package:dartz/dartz.dart';

class GetCachedTuteeAssignmentToSet
    extends UseCase<TuteeAssignmentParams, NoParams> {
  GetCachedTuteeAssignmentToSet({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, TuteeAssignmentParams>> call(NoParams params) async {
    final Either<Failure, TuteeAssignmentParams> params =
        await repo.getCachedTuteeAssignmentToSet();
    return params;
  }
}
