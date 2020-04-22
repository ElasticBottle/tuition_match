part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class UserEnterHompage extends UserProfileEvent {}

class RefreshUserProfile extends UserProfileEvent {
  const RefreshUserProfile({this.user});
  final User user;
  @override
  String toString() => '''RefreshUserProfile { user : $user}''';
}

class UpdateProfileSuccess extends UserProfileEvent {
  const UpdateProfileSuccess(String msg) : _msg = msg;

  final String _msg;

  String get message => _msg;

  @override
  bool get stringify => true;
}
