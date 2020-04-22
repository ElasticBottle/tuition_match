part of 'user_profile_page_bloc.dart';

abstract class UserProfilePageState extends Equatable {
  UserProfilePageState copyWith();
}

class UserProfilePageStateImpl extends UserProfilePageState {
  UserProfilePageStateImpl();

  factory UserProfilePageStateImpl.initial() {
    return UserProfilePageStateImpl();
  }

  @override
  UserProfilePageStateImpl copyWith() {
    return UserProfilePageStateImpl();
  }

  @override
  List<Object> get props => [];
}
