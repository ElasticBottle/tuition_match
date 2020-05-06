import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetCacheTutorProfile extends UseCase<TutorProfile, NoParams> {
  GetCacheTutorProfile({this.tutorProfileRepo});
  final UserRepo tutorProfileRepo;

  @override
  Future<Either<Failure, TutorProfile>> call(NoParams params) async {
    return await tutorProfileRepo.getCachedTutorProfileToSet();
  }
}
