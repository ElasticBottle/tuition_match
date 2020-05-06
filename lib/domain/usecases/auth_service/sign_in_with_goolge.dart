import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';

class SignInWithGoogle extends UseCase<User, NoParams> {
  SignInWithGoogle({this.repo});
  AuthServiceRepo repo;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    final Either<Failure, User> result = await repo.signInWithGoogle();
    return result;
  }
}
