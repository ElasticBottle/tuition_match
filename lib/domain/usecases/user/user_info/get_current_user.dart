import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUser extends UseCase<User, NoParams> {
  GetCurrentUser({this.repo});
  UserRepo repo;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    final result = await repo.getCurrentLoggedInUser();
    return result;
  }
}
