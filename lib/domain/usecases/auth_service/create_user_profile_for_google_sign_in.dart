import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:dartz/dartz.dart';

class CreateUserProfileForGoogleSignIn
    extends UseCase<bool, CreateAccountParams> {
  CreateUserProfileForGoogleSignIn({this.repo});
  AuthServiceRepo repo;
  @override
  Future<Either<Failure, bool>> call(CreateAccountParams params) async {
    final Either<Failure, bool> success =
        await repo.createUserProfileForGoogleSignIn(
      phoneNum: params.phoneNum,
      firstName: params.firstName,
      lastName: params.lastName,
    );
    return success;
  }
}
