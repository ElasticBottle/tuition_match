import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';

/// Creates a new firebaase document.
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
  CreateUserDocument({this.repo});
  UserRepo repo;

  @override
  Future<Either<Failure, bool>> call(CreateUserDocumentParams params) async {
    Either<Failure, bool> success;
    final Either<Failure, User> currentUser =
        await repo.getCurrentLoggedInUser();
    currentUser.fold(
      (l) => success = Left<Failure, bool>(l),
      (r) async {
        success = await repo.createNewUserDocument(
          uid: r.uid,
          photoUrl: r.photoUrl,
          phoneNum: params.phoneNum,
          firstname: params.firstName,
          lastname: params.lastName,
        );
      },
    );
    return success;
  }
}

class CreateUserDocumentParams extends Equatable {
  const CreateUserDocumentParams({
    this.firstName,
    this.lastName,
    this.phoneNum,
  });
  final String firstName;
  final String lastName;
  final String phoneNum;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phoneNum,
      ];

  @override
  String toString() =>
      'CreateUserDocumentParams(firstName: $firstName, lastName: $lastName, phoneNum: $phoneNum)';
}
