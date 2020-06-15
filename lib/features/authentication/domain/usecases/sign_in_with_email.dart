import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SignInWithEmail
    extends UseCase<AuthenticatedUser, SignInWithEmailParams> {
  SignInWithEmail({this.repo});
  AuthenticationRepo repo;
  @override
  Future<Either<Failure, AuthenticatedUser>> call(
      SignInWithEmailParams params) async {
    final Either<Failure, AuthenticatedUser> success =
        await repo.signInWithEmailAndPassword(params.email, params.password);
    return success;
  }
}

class SignInWithEmailParams extends Equatable {
  const SignInWithEmailParams({this.email, this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'SignInWithEmailParams { email : $email, password: $password }';
}
