import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';

class SignInWithEmail extends UseCase<User, EmailSignInParams> {
  SignInWithEmail({this.repo});
  AuthServiceRepo repo;
  @override
  Future<Either<Failure, User>> call(EmailSignInParams params) async {
    final Either<Failure, User> success =
        await repo.signInWithEmailAndPassword(params.email, params.password);
    return success;
  }
}

class EmailSignInParams extends Params {
  const EmailSignInParams({this.email, this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];

  @override
  String toString() =>
      'EmailSignInParams { email : $email, password: $password }';
}
