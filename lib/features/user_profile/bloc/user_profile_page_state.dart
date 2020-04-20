part of 'user_profile_page_bloc.dart';

abstract class UserProfilePageState extends Equatable {
  UserModel get userModel;

  UserProfilePageState copyWith(UserModel userModel);
}

class UserProfilePageStateImpl extends UserProfilePageState {
  UserProfilePageStateImpl({UserModel userModel}) : _userModel = userModel;

  factory UserProfilePageStateImpl.initial() {
    return UserProfilePageStateImpl(userModel: UserModel.empty());
  }

  final UserModel _userModel;
  @override
  UserModel get userModel => _userModel;

  @override
  UserProfilePageStateImpl copyWith(UserModel userModel) {
    return UserProfilePageStateImpl(
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object> get props => [userModel];
}
