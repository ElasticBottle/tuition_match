part of 'auth_service_bloc.dart';

abstract class AuthServiceState extends Equatable {
  const AuthServiceState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthServiceState {}

class Authenticated extends AuthServiceState {
  const Authenticated({
    this.isEmailVerified,
    this.userProfile,
  });

  final bool isEmailVerified;
  final User userProfile;

  @override
  List<Object> get props => [isEmailVerified, userProfile];

  @override
  String toString() => '''Authenticated { 
    isEmailVerified: $isEmailVerified 
    userProfile : $userProfile
  }''';
}

class Unauthenticated extends AuthServiceState {}
