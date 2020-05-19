part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  User get userProfile;
  String get updateProfileSuccessMsg;
  bool get updateProfileSuccess;
  bool get hasCachedProfile;

  UserProfileState copyWith({
    User userProfile,
    String updateProfileSuccessMsg,
    bool updateProfileSuccess,
    bool hasCachedProfile,
  });
}

class UserProfileStateImpl implements UserProfileState {
  const UserProfileStateImpl({
    User userProfile,
    String updateProfileSuccessMsg,
    bool updateProfileSuccess,
    bool hasCachedProfile,
  })  : _userProfile = userProfile,
        _updateProfileSuccessMsg = updateProfileSuccessMsg,
        _updateProfileSuccess = updateProfileSuccess,
        _hasCachedProfile = hasCachedProfile;

  factory UserProfileStateImpl.empty() {
    return UserProfileStateImpl(
      userProfile: User(),
      updateProfileSuccess: false,
      updateProfileSuccessMsg: '',
      hasCachedProfile: false,
    );
  }

  final User _userProfile;
  final bool _updateProfileSuccess;
  final String _updateProfileSuccessMsg;
  final bool _hasCachedProfile;

  @override
  User get userProfile => _userProfile;
  @override
  String get updateProfileSuccessMsg => _updateProfileSuccessMsg;
  @override
  bool get updateProfileSuccess => _updateProfileSuccess;
  @override
  bool get hasCachedProfile => _hasCachedProfile;

  @override
  UserProfileState copyWith({
    User userProfile,
    String updateProfileSuccessMsg,
    bool updateProfileSuccess,
    bool hasCachedProfile,
  }) {
    return UserProfileStateImpl(
      userProfile: userProfile ?? this.userProfile,
      updateProfileSuccessMsg:
          updateProfileSuccessMsg ?? this.updateProfileSuccessMsg,
      updateProfileSuccess: updateProfileSuccess ?? this.updateProfileSuccess,
      hasCachedProfile: hasCachedProfile ?? this.hasCachedProfile,
    );
  }

  @override
  List<Object> get props => [userProfile];
  @override
  bool get stringify => true;

  @override
  String toString() {
    return 'UserProfileStateImpl(_userProfile: $_userProfile, _updateProfileSuccess: $_updateProfileSuccess, _updateProfileSuccessMsg: $_updateProfileSuccessMsg, _hasCachedProfile: $_hasCachedProfile)';
  }
}
