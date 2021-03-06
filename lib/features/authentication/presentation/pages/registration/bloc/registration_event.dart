part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
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

class PhoneNumChanged extends RegistrationEvent {
  const PhoneNumChanged({@required this.phoneNum});
  final String phoneNum;

  @override
  List<Object> get props => [phoneNum];

  @override
  String toString() => 'PhoneNumChanged { phoneNum: $phoneNum }';
}

class CountryCodeChanged extends RegistrationEvent {
  const CountryCodeChanged({@required this.countryCode});
  final String countryCode;

  @override
  List<Object> get props => [countryCode];

  @override
  String toString() => 'CountryCodeChanged { countryCode: $countryCode }';
}

class Submitted extends RegistrationEvent {
  const Submitted({
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.password,
    @required this.phoneNum,
    @required this.countryCode,
  });
  final String email;
  final String password;
  final String phoneNum;
  final String countryCode;

  final String firstName;
  final String lastName;

  @override
  List<Object> get props =>
      [email, password, firstName, lastName, phoneNum, countryCode];

  @override
  String toString() {
    return 'Submitted(email: $email, password: $password, phoneNum: $phoneNum, firstName: $firstName, lastName: $lastName,countryCode: $countryCode)';
  }
}

class ExternalSignUpSubmission extends RegistrationEvent {
  const ExternalSignUpSubmission({
    @required this.firstName,
    @required this.lastName,
    @required this.phoneNum,
    @required this.countryCode,
  });
  final String countryCode;
  final String phoneNum;
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName, phoneNum, countryCode];

  @override
  String toString() =>
      'ExternalSignInSubmission(countryCode: $countryCode, phoneNum: $phoneNum, firstName: $firstName, lastName: $lastName)';
}
