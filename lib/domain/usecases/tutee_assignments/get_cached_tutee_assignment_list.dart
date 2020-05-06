import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class GetCachedTuteeAssignmentList
    extends UseCase<List<TuteeAssignment>, NoParams> {
  GetCachedTuteeAssignmentList({this.repo});
  TuteeAssignmentRepo repo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> call(NoParams params) async {
    final result = await repo.getCachedAssignmentList();
    return result;
  }
}
