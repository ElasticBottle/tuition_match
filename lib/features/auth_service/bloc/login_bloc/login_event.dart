part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent {
  const EmailChanged({this.email});
  final String email;

  @override
  List<Object> get props => [email];

  @override
  String toString() => '''EmailChanged { email: $email }''';
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged({this.password});
  final String password;
  @override
  List<Object> get props => [password];

  @override
  String toString() => '''PasswordChanged {passwrod : $password}''';
}

class LoginWithGooglePressed extends LoginEvent {}

class LoginWithCredentialsPressed extends LoginEvent {
  const LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}
