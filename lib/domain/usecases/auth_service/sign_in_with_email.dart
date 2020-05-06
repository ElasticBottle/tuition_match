import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class SignInWithEmail extends UseCase<User, SignInWithEmailParams> {
  SignInWithEmail({this.repo});
  AuthServiceRepo repo;
  @override
  Future<Either<Failure, User>> call(SignInWithEmailParams params) async {
    final Either<Failure, User> success =
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
