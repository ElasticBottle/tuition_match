import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:dartz/dartz.dart';

class SignOut extends UseCase<void, NoParams> {
  SignOut({this.repo});
  AuthenticationRepo repo;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final Either<Failure, void> result = await repo.signOut();
    return result;
  }
}
