import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:dartz/dartz.dart';

/// Sends an email to user for verification
///
/// Returns Either:
/// * __[true]__ if successful.
/// * __[SendEmailFailure]__ if unsuccessful
/// * __[NetworkFailure]__ when called without internet access on user's device
class SendEmailVerification extends UseCase<void, NoParams> {
  SendEmailVerification({this.repo});
  AuthenticationRepo repo;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    final Either<Failure, bool> result = await repo.sendEmailVerification();
    return result;
  }
}
