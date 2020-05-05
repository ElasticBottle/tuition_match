import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

class SetUserProfilePhoto extends UseCase<User, NoParams> {
  SetUserProfilePhoto({this.repo});
  UserRepo repo;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    // TODO(ElasticeBottle): implement
    // final result = await repo.getCurrentUser();
    // return result;
  }
}
