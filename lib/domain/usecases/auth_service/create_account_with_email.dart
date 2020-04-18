import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CreateAccountWithEmail extends UseCase<bool, CreateAccountParams> {
  CreateAccountWithEmail({this.repo});
  AuthServiceRepo repo;
  @override
  Future<Either<Failure, bool>> call(CreateAccountParams params) async {
    final Either<Failure, bool> success = await repo.createAccountWithEmail(
      email: params.email,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
    );
    return success;
  }
}

class CreateAccountParams extends Equatable {
  const CreateAccountParams({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phoneNum,
  });
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNum;

  @override
  List<Object> get props => [email, password, firstName, lastName, phoneNum];

  @override
  String toString() =>
      'CreateAccoutnParams { email : $email, password: $password ,  firstname: $firstName, lastname: $lastName, phoneNum: $phoneNum}';
}
