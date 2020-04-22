part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  UserModel get userProfile;
  String get updateProfileSuccessMsg;
  bool get updateProfileSuccess;

  UserProfileState copyWith({
    User userProfile,
    String updateProfileSuccessMsg,
    bool updateProfileSuccess,
  });
}

class UserProfileStateImpl implements UserProfileState {
  const UserProfileStateImpl({
    UserModel userProfile,
    String updateProfileSuccessMsg,
    bool updateProfileSuccess,
  })  : _userProfile = userProfile,
        _updateProfileSuccessMsg = updateProfileSuccessMsg,
        _updateProfileSuccess = updateProfileSuccess;

  factory UserProfileStateImpl.empty() {
    return UserProfileStateImpl(
      userProfile: UserModel(),
      updateProfileSuccess: false,
      updateProfileSuccessMsg: '',
    );
  }

  final UserModel _userProfile;
  final bool _updateProfileSuccess;
  final String _updateProfileSuccessMsg;

  @override
  UserModel get userProfile => _userProfile;
  @override
  String get updateProfileSuccessMsg => _updateProfileSuccessMsg;
  @override
  bool get updateProfileSuccess => _updateProfileSuccess;

  @override
  UserProfileState copyWith({
    User userProfile,
    String updateProfileSuccessMsg,
    bool updateProfileSuccess,
  }) {
    return UserProfileStateImpl(
      userProfile: userProfile ?? this.userProfile,
      updateProfileSuccessMsg:
          updateProfileSuccessMsg ?? this.updateProfileSuccessMsg,
      updateProfileSuccess: updateProfileSuccess ?? this.updateProfileSuccess,
    );
  }

  @override
  List<Object> get props => [userProfile];
  @override
  bool get stringify => true;

  @override
  String toString() => '''UserProfileStateImpl(
        _userProfile: $_userProfile, _updateProfileSuccess: $_updateProfileSuccess, 
        _updateProfileSuccessMsg: $_updateProfileSuccessMsg)''';
}
