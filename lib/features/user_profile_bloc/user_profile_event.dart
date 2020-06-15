part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}

class UserEnterHompage extends UserProfileEvent {
  UserEnterHompage({this.uid});
  final String uid;

  @override
  List<Object> get props => [uid];

  @override
  String toString() => 'UserEnterHompage(uid: $uid)';
}

class RefreshUserProfile extends UserProfileEvent {
  const RefreshUserProfile({this.user});
  final User user;

  @override
  List<Object> get props => [user];
  @override
  String toString() => '''RefreshUserProfile { user : $user}''';
}

class UpdateProfileSuccess extends UserProfileEvent {
  const UpdateProfileSuccess(String msg) : _msg = msg;

  final String _msg;

  String get message => _msg;

  @override
  List<Object> get props => [_msg];

  @override
  bool get stringify => true;

  @override
  String toString() => 'UpdateProfileSuccess(_msg: $_msg)';
}

class CachedProfileToSet extends UserProfileEvent {
  const CachedProfileToSet(this.isCache);

  final bool isCache;

  @override
  List<Object> get props => [isCache];

  @override
  String toString() => 'CachedProfileToSet(isCache: $isCache)';
}
