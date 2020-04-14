import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepo {
  Stream<User> userStream();
  Stream<User> userProfileStream(String uid);
  Future<Either<Failure, User>> getCurrentLoggedInUser();
  Future<Either<Failure, User>> getUserInfo(String uid);
  Future<Either<Failure, PrivateUserInfo>> getUserPrivateInfo(String uid);
  Future<Either<Failure, void>> createNewUser({
    String email,
    String firstname,
    String lastname,
    String phoneNum,
  });
  void dispose();
}
