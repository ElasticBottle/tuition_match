import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateTuteeAssignment extends UseCase<bool, TuteeAssignment> {
  UpdateTuteeAssignment({this.repo});
  final UserRepo repo;
  @override
  Future<Either<Failure, bool>> call(TuteeAssignment params) async {
    final Either<Failure, bool> success =
        await repo.updateTuteeAssignment(params);
    return success;
  }
}
