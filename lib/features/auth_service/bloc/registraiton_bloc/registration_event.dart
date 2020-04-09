part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class UsernameChanged extends RegistrationEvent {
  const UsernameChanged({@required this.username});
  final String username;

  @override
  List<Object> get props => [username];

  @override
  String toString() => 'UsernameChanged { username :$username }';
}

class FirstNameChanged extends RegistrationEvent {
  const FirstNameChanged({@required this.firstName});
  final String firstName;

  @override
  List<Object> get props => [firstName];

  @override
  String toString() => 'FirstNameChanged { firstName :$firstName }';
}

class LastNameChanged extends RegistrationEvent {
  const LastNameChanged({@required this.lastName});
  final String lastName;

  @override
  List<Object> get props => [lastName];

  @override
  String toString() => 'LastNameChanged { lastName :$lastName }';
}

class EmailChanged extends RegistrationEvent {
  const EmailChanged({@required this.email});
  final String email;

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordChanged extends RegistrationEvent {
  const PasswordChanged({@required this.password});
  final String password;

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends RegistrationEvent {
  const Submitted({
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.password,
  });
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [email, password];

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}
