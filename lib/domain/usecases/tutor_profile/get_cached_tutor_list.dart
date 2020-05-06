import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/tutor_profile_repo.dart';
import 'package:dartz/dartz.dart';

class GetCachedTutorList extends UseCase<List<TutorProfile>, NoParams> {
  GetCachedTutorList({this.repo});
  TutorProfileRepo repo;

  @override
  Future<Either<Failure, List<TutorProfile>>> call(NoParams params) async {
    final result = await repo.getCachedProfileList();
    return result;
  }
}
