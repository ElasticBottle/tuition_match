part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  const Authenticated({
    this.userProfile,
  });

  final AuthenticatedUser userProfile;
  @override
  List<Object> get props => [userProfile];

  @override
  String toString() => '''Authenticated { 
    userProfile : $userProfile,
  }''';
}

class Unauthenticated extends AuthenticationState {}

class FirstTimeAppLaunch extends AuthenticationState {}

class MissingUserInfo extends AuthenticationState {}

class UnverifiedEmail extends AuthenticationState {}
