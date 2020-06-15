import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:dartz/dartz.dart';

class SignInWithGoogle extends UseCase<AuthenticatedUser, NoParams> {
  SignInWithGoogle({this.repo});
  AuthenticationRepo repo;

  @override
  Future<Either<Failure, AuthenticatedUser>> call(NoParams params) async {
    final Either<Failure, AuthenticatedUser> result =
        await repo.signInWithGoogle();
    return result;
  }
}
