import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:dartz/dartz.dart';

/// Retrieves the currently logged in user if any
///
/// [AuthenticatedUser] returned only contains identity info.
///
/// If attempting to retrieve userProfile, use
class GetCurrentUser extends UseCase<AuthenticatedUser, NoParams> {
  GetCurrentUser({this.repo});
  final AuthenticationRepo repo;

  @override
  Future<Either<Failure, AuthenticatedUser>> call(NoParams params) async {
    final Either<Failure, AuthenticatedUser> result =
        await repo.getCurrentLoggedInUser();
    return result;
  }
}
