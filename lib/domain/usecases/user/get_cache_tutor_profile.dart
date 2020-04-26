import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/repositories/tutor_profile_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetCacheTutorProfile extends UseCase<TutorProfile, NoParams> {
  GetCacheTutorProfile({this.tutorProfileRepo});
  final TutorProfileRepo tutorProfileRepo;

  @override
  Future<Either<Failure, TutorProfile>> call(NoParams params) async {
    return await tutorProfileRepo.getCachedTutorProfileToSet();
  }
}
