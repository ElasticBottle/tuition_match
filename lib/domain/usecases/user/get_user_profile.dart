import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

class GetUserProfile extends UseCase<User, UserParams> {
  GetUserProfile({this.repo});
  UserRepo repo;

  @override
  Future<Either<Failure, User>> call(UserParams params) async {
    final result = await repo.getUserInfo(params.username);
    return result;
  }
}

class UserParams extends Params {
  const UserParams({this.username});
  final String username;

  @override
  String toString() => 'UserParams { username: $username}';
}
