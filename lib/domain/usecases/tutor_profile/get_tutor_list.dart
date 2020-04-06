import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:dartz/dartz.dart';

class GetTutuorList extends UseCase<List<TutorProfile>, NoParams> {
  GetTutuorList({this.repo});
  TutorProfileRepo repo;

  @override
  Future<Either<Failure, List<TutorProfile>>> call(NoParams params) async {
    final result = await repo.getAssignmentList();
    return result;
  }
}
