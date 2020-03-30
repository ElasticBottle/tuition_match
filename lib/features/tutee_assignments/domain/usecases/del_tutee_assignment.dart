import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/set_tutee_assignment.dart';
import 'package:dartz/dartz.dart';

class DelTuteeAssignment extends UseCase<bool, DelParams> {
  DelTuteeAssignment({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, bool>> call(DelParams params) async {
    final Either<Failure, bool> success = await repo.delAssignment(params);
    return success;
  }
}

class DelParams extends Params {
  const DelParams({this.postId});

  final String postId;

  @override
  List<Object> get props => [postId];
}
