import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';

///Returns a [Stream<User>] listening to the Auth state
///
///Triggers everytime a user logs in or out
///
///User class that is return here only contains identity info:
///* [uid]
///* [isEmailVerified]
///* [photoUrl] - can be null
class UserStream {
  UserStream({this.repo});
  AuthServiceRepo repo;

  Stream<User> stream() {
    return repo.userStream();
  }
}
