import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/data/models/del_params.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
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
