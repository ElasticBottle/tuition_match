part of 'auth_service_bloc.dart';

abstract class AuthServiceEvent extends Equatable {
  const AuthServiceEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthServiceEvent {}

class LoggedIn extends AuthServiceEvent {}

class LoggedOut extends AuthServiceEvent {}
