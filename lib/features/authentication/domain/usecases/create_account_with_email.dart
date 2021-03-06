import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:cotor/features/authentication/domain/usecases/create_user_document.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Creates a Firebase auth account for the user.
/// Creates a user document in firebase for the user.
///
/// Return Failure type is one of:
///
/// [NetworkFailure]: when there is no internet connection on user's current device
///
/// [AuthenticationFailure]: when there is error creating firebase Auth account for user
///
/// [NoUserFailure]: when the created firebaseAuth user is somehow not logged in after account creation
///
/// [serverFailure]: when there is error creating the documents
class CreateAccountWithEmail
    extends UseCase<bool, CreateAccountWithEmailParams> {
  CreateAccountWithEmail({
    this.repo,
    this.createUserDocument,
  });
  AuthenticationRepo repo;
  CreateUserDocument createUserDocument;
  @override
  Future<Either<Failure, bool>> call(
      CreateAccountWithEmailParams params) async {
    final Either<Failure, AuthenticatedUser> success =
        await repo.createAccountWithEmail(
      email: params.email,
      password: params.password,
    );
    return success.fold(
      (l) => Left<Failure, bool>(l),
      (r) async => await createUserDocument(CreateUserDocumentParams(
        uid: r.uid,
        firstName: params.firstName,
        lastName: params.lastName,
        phoneNum: params.phoneNum,
        countryCode: params.countryCode,
      )),
    );
  }
}

class CreateAccountWithEmailParams extends Equatable {
  const CreateAccountWithEmailParams(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.phoneNum,
      this.countryCode});
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNum;
  final String countryCode;

  @override
  List<Object> get props =>
      [email, password, firstName, lastName, phoneNum, countryCode];

  @override
  String toString() =>
      'CreateAccountParams { email : $email, password: $password ,  firstName: $firstName, lastName: $lastName, phoneNum: $phoneNum, countryCode: $countryCode}';
}
