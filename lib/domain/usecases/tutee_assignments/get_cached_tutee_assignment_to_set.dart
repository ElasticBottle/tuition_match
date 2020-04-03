import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class GetCachedTuteeAssignmentToSet
    extends UseCase<TuteeAssignmentModel, NoParams> {
  GetCachedTuteeAssignmentToSet({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, TuteeAssignmentModel>> call(NoParams params) async {
    final Either<Failure, TuteeAssignmentModel> params =
        await repo.getCachedTuteeAssignmentToSet();
    return params;
  }
}
