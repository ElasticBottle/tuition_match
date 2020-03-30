import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class SetTuteeAssignment extends UseCase<bool, TuteeAssignmentParams> {
  SetTuteeAssignment({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, bool>> call(TuteeAssignmentParams params) async {
    final Either<Failure, bool> success = await repo.setTuteeAssignment(params);
    return success;
  }
}

class TuteeAssignmentParams extends Params {
  @override
  List<Object> get props => [];
}
