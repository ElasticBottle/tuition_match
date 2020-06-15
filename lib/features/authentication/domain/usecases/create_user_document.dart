import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';

/// Creates a new Firebaase document.
/// Requires a new user without an existing document ot already be logged in
/// Returns [bool] true is successful
///
/// Return Failure type is one of:
///
/// [NetworkFailure]: when there is no internet connection on user's current device
///
/// [NoUserFailure]: when there is no current user logged in
///
/// [serverFailure]: when there is error creating the documents
class CreateUserDocument extends UseCase<bool, CreateUserDocumentParams> {
  CreateUserDocument({
    this.repo,
  });
  final AuthenticationRepo repo;

  @override
  Future<Either<Failure, bool>> call(CreateUserDocumentParams params) async {
    final Either<Failure, bool> success = await repo.createNewUserDocument(
      uid: params.uid,
      countryCode: params.countryCode,
      phoneNum: params.phoneNum,
      firstName: params.firstName,
      lastName: params.lastName,
    );
    return success;
  }
}

class CreateUserDocumentParams extends Equatable {
  const CreateUserDocumentParams(
      {this.uid,
      this.firstName,
      this.lastName,
      this.phoneNum,
      this.countryCode});
  final String uid;
  final String firstName;
  final String lastName;
  final String phoneNum;
  final String countryCode;

  @override
  List<Object> get props => [firstName, lastName, phoneNum, countryCode];

  @override
  String toString() {
    return 'CreateUserDocumentParams(uid: $uid, firstName: $firstName, lastName: $lastName, phoneNum: $phoneNum, countryCode: $countryCode)';
  }
}
