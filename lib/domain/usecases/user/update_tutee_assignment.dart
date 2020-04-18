import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateTuteeAssignment extends UseCase<bool, TuteeAssignment> {
  UpdateTuteeAssignment({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, bool>> call(TuteeAssignment params) async {
    final Either<Failure, bool> success =
        await repo.updateTuteeAssignment(params);
    return success;
  }
}
