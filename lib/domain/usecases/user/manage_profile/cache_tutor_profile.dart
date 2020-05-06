import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class CacheTutorProfile extends UseCase<void, TutorProfile> {
  CacheTutorProfile({this.tutorProfileRepo});
  final UserRepo tutorProfileRepo;

  @override
  Future<Either<Failure, void>> call(TutorProfile params) async {
    return await tutorProfileRepo.cacheTutorProfileToSet(params);
  }
}
