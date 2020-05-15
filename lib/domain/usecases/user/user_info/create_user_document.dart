import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:cotor/core/error/failures.dart';
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
  CreateUserDocument({
    this.userRepo,
    this.authServiceRepo,
  });
  final AuthServiceRepo authServiceRepo;
  final UserRepo userRepo;

  @override
  Future<Either<Failure, bool>> call(CreateUserDocumentParams params) async {
    Either<Failure, bool> success;
    final Either<Failure, User> currentUser =
        await authServiceRepo.getCurrentLoggedInUser();
    return currentUser.fold(
      (l) {
        success = Left<Failure, bool>(l);
        return success;
      },
      (r) async {
        success = await userRepo.createNewUserDocument(
          uid: r.identity.uid,
          photoUrl: r.identity.photoUrl,
          countryCode: params.countryCode,
          phoneNum: params.phoneNum,
          firstname: params.firstName,
          lastname: params.lastName,
        );
        return success;
      },
    );
  }
}

class CreateUserDocumentParams extends Equatable {
  const CreateUserDocumentParams(
      {this.firstName, this.lastName, this.phoneNum, this.countryCode});
  final String firstName;
  final String lastName;
  final String phoneNum;
  final String countryCode;

  @override
  List<Object> get props => [firstName, lastName, phoneNum, countryCode];

  @override
  String toString() =>
      'CreateUserDocumentParams(firstName: $firstName, lastName: $lastName, phoneNum: $phoneNum, countryCode: $countryCode)';
}
