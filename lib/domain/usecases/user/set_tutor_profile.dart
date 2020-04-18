import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/tutor_profile_repo.dart';
import 'package:dartz/dartz.dart';

class SetTutorProfile extends UseCase<bool, TutorProfile> {
  SetTutorProfile({this.repo});
  TutorProfileRepo repo;
  @override
  Future<Either<Failure, bool>> call(TutorProfile params) async {
    final Either<Failure, bool> success = await repo.setTutorProfile(params);
    return success;
  }
}
