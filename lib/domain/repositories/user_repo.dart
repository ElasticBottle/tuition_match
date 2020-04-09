import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepo {
  Future<Either<Failure, User>> getCurrentLoggedInUser();
  Future<Either<Failure, User>> getUserInfo(String username);
  Future<Either<Failure, PrivateUserInfo>> getUserPrivateInfo(String username);
  Future<Either<Failure, bool>> createNewUser({
    String emaail,
    String username,
    String firstname,
    String lastname,
  });
  void dispose();
}
