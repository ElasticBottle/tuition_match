part of 'user_profile_bloc.dart';

class UserProfileState extends Equatable {
  const UserProfileState({
    this.userProfile,
  });

  factory UserProfileState.empty() {
    return UserProfileState(userProfile: User());
  }

  final User userProfile;

  UserProfileState copyWith(User userProfile) {
    return UserProfileState(userProfile: userProfile ?? this.userProfile);
  }

  @override
  List<Object> get props => [userProfile];

  @override
  String toString() => 'UserProfileState { userProfile : $userProfile}';
}
