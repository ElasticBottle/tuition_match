import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateTutorProfile extends UseCase<bool, TutorProfile> {
  UpdateTutorProfile({this.repo});
  final UserRepo repo;
  @override
  Future<Either<Failure, bool>> call(TutorProfile params) async {
    final Either<Failure, bool> success = await repo.updateTutorProfile(params);
    return success;
  }
}
