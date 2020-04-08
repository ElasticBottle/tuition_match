part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class EmailChanged extends LoginEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => '''EmailChanged {}''';
}

class PasswordChanged extends LoginEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => '''PasswordChanged {}''';
}

class SubmitForm extends LoginEvent {
  SubmitForm();
  final String email;
  final String password;
  @override
  List<Object> get props => [
        email,
        password,
      ];

  @override
  String toString() => '''SubmitForm {
    emai : $email ,
    password : $password ,
  }''';
}

class LoginWithGooglePressed extends LoginEvent {}

class LoginWithCredentialsPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginWithCredentialsPressed({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'LoginWithCredentialsPressed { email: $email, password: $password }';
  }
}
