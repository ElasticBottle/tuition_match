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
  String toString() => '''EmailChanged {}''';
}

class PasswordChanged extends LoginEvent {
  const PasswordChanged({this.password});
  final String password;
  @override
  List<Object> get props => [];

  @override
  String toString() => '''PasswordChanged {}''';
}

// class SubmitForm extends LoginEvent {
//   const SubmitForm({
//     this.email,
//     this.password,
//   });
//   final String email;
//   final String password;
//   @override
//   List<Object> get props => [
//         email,
//         password,
//       ];

//   @override
//   String toString() => '''SubmitForm {
//     emai : $email ,
//     password : $password ,
//   }''';
// }

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
