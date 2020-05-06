import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';

class UserProfileStream {
  UserProfileStream({this.repo});
  UserRepo repo;

  Stream<User> call(String uid) {
    return repo.userProfileStream(uid);
  }
}
