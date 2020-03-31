import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class UpdateTuteeAssignment extends UseCase<bool, TuteeAssignmentModel> {
  UpdateTuteeAssignment({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, bool>> call(TuteeAssignmentModel params) async {
    final Either<Failure, bool> success =
        await repo.updateTuteeAssignment(params);
    return success;
  }
}
