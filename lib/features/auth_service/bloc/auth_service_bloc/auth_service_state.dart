part of 'auth_service_bloc.dart';

abstract class AuthServiceState extends Equatable {
  const AuthServiceState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthServiceState {}

class Authenticated extends AuthServiceState {
  const Authenticated({
    this.userProfile,
  });

  final User userProfile;
  @override
  List<Object> get props => [userProfile];

  @override
  String toString() => '''Authenticated { 
    userProfile : $userProfile,
  }''';
}

class Unauthenticated extends AuthServiceState {}

class FirstTimeAppLaunch extends AuthServiceState {}

class NewGoogleUser extends AuthServiceState {}

class UnverifiedEmail extends AuthServiceState {}
