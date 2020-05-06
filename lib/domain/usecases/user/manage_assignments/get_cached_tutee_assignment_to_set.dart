import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetCachedTuteeAssignmentToSet extends UseCase<TuteeAssignment, NoParams> {
  GetCachedTuteeAssignmentToSet({this.repo});
  final UserRepo repo;
  @override
  Future<Either<Failure, TuteeAssignment>> call(NoParams params) async {
    final Either<Failure, TuteeAssignment> params =
        await repo.getCachedTuteeAssignmentToSet();
    return params;
  }
}
