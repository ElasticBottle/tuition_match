import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/repositories/tutor_profile_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class CacheTutorProfile extends UseCase<void, TutorProfile> {
  CacheTutorProfile({this.tutorProfileRepo});
  final TutorProfileRepo tutorProfileRepo;

  @override
  Future<Either<Failure, void>> call(TutorProfile params) async {
    return await tutorProfileRepo.cacheTutorProfileToSet(params);
  }
}
