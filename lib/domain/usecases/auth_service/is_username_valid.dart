import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';

class IsUsernameValid extends UseCase<bool, UsernameValidatorParams> {
  IsUsernameValid({this.repo});
  AuthServiceRepo repo;
  @override
  Future<Either<Failure, bool>> call(UsernameValidatorParams params) async {
    final Either<Failure, bool> success =
        await repo.isUsernameValid(params.username);
    return success;
  }
}

class UsernameValidatorParams extends Params {
  const UsernameValidatorParams({this.username});
  final String username;

  @override
  List<Object> get props => [
        username,
      ];

  @override
  String toString() => 'UsernameValidatorParams { username : $username, }';
}
