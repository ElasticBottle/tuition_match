import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:dartz/dartz.dart';

class CreateUserProfileForGoogleSignIn
    extends UseCase<void, CreateAccountParams> {
  CreateUserProfileForGoogleSignIn({this.repo});
  UserRepo repo;
  @override
  Future<Either<Failure, void>> call(CreateAccountParams params) async {
    final Either<Failure, void> success = await repo.createNewUser(
      phoneNum: params.phoneNum,
      firstname: params.firstName,
      lastname: params.lastName,
    );
    return success;
  }
}
