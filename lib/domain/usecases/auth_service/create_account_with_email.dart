import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';

class CreateAccountWithEmail extends UseCase<bool, CreateAccoutnParams> {
  CreateAccountWithEmail({this.repo});
  AuthServiceRepo repo;
  @override
  Future<Either<Failure, bool>> call(CreateAccoutnParams params) async {
    final Either<Failure, bool> success = await repo.createAccountWithEmail(
      email: params.email,
      password: params.password,
      username: params.username,
      firstName: params.firstName,
      lastName: params.lastName,
    );
    return success;
  }
}

class CreateAccoutnParams extends Params {
  const CreateAccoutnParams({
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  });
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [email, password, username, firstName, lastName];

  @override
  String toString() =>
      'CreateAccoutnParams { email : $email, password: $password , username: $username, firstname: $firstName, lastname: $lastName}';
}
