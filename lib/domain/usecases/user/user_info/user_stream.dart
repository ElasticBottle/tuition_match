import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';

class UserStream {
  UserStream({this.repo});
  UserRepo repo;

  Stream<User> stream() {
    return repo.userStream();
  }
}
