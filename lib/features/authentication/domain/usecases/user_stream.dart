import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';

///Returns a [Stream<AuthenticatedUser>] listening to the Auth state
///
///Triggers every time a user logs in or out
///
///User class that is return here only contains identity info:
///* [uid]
///* [isEmailVerified]
///* [photoUrl] - can be null
class UserStream {
  UserStream({this.repo});
  AuthenticationRepo repo;

  Stream<AuthenticatedUser> stream() {
    return repo.userStream();
  }
}
