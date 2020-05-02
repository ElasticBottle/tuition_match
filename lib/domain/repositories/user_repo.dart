import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepo {
  Stream<User> userStream();
  Stream<User> userProfileStream(String uid);
  Future<Either<Failure, User>> getCurrentLoggedInUser();
  Future<Either<Failure, User>> getUserInfo(String uid);
  Future<Either<Failure, PrivateUserInfo>> getUserPrivateInfo(String uid);
  Future<Either<Failure, void>> createNewUserDocument({
    String firstname,
    String lastname,
    String phoneNum,
  });
  Future<Either<Failure, bool>> requestTutor({
    String uid,
    TuteeAssignment assignment,
    bool isNewAssignment,
    bool toSave,
  });
  void dispose();
}
