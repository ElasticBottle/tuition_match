import 'package:meta/meta.dart';

class AuthenticatedUser {
  AuthenticatedUser(
      {@required this.uid,
      @required this.photoUrl,
      @required this.isEmailVerified});
  final String uid;
  final String photoUrl;
  final bool isEmailVerified;

  @override
  String toString() =>
      'AuthenticatedUser(uid: $uid, photoUrl: $photoUrl, isEmailVerified: $isEmailVerified)';
}
