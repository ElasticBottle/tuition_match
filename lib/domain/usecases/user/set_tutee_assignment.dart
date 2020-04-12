import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class SetTuteeAssignment extends UseCase<bool, TuteeAssignmentModel> {
  SetTuteeAssignment({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, bool>> call(TuteeAssignmentModel params) async {
    final Either<Failure, bool> success = await repo.setTuteeAssignment(params);
    return success;
  }
}

// class TuteeAssignmentParams extends Params {

//   factory TuteeAssignmentParams.fromMap(
//       Map<String, dynamic> json);

//   Map<String, dynamic> toMap() {}

//   @override
//   List<Object> get props => [];
// }
