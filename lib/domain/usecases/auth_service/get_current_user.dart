import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetCurrentUser extends UseCase<User, NoParams> {
  GetCurrentUser({this.repo});
  final AuthServiceRepo repo;

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    final dynamic result = await repo.getCurrentLoggedInUser();
    return result;
  }
}
