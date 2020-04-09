import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';

class SendEmailVerification extends UseCase<void, NoParams> {
  SendEmailVerification({this.repo});
  AuthServiceRepo repo;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final Either<Failure, void> result = await repo.sendEmailVerification();
    return result;
  }
}
