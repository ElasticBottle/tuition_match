part of 'first_time_google_sign_in_bloc.dart';

abstract class FirstTimeGoogleSignInEvent extends Equatable {
  const FirstTimeGoogleSignInEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends FirstTimeGoogleSignInEvent {
  const FirstNameChanged({@required this.firstName});
  final String firstName;

  @override
  List<Object> get props => [firstName];

  @override
  String toString() => 'FirstNameChanged { firstName :$firstName }';
}

class LastNameChanged extends FirstTimeGoogleSignInEvent {
  const LastNameChanged({@required this.lastName});
  final String lastName;

  @override
  List<Object> get props => [lastName];

  @override
  String toString() => 'LastNameChanged { lastName :$lastName }';
}

class PhoneNumChanged extends FirstTimeGoogleSignInEvent {
  const PhoneNumChanged({@required this.phoneNum});
  final String phoneNum;

  @override
  List<Object> get props => [phoneNum];

  @override
  String toString() => 'PhoneNumChanged { phoneNum: $phoneNum }';
}

class Submitted extends FirstTimeGoogleSignInEvent {
  const Submitted({
    @required this.firstName,
    @required this.lastName,
    @required this.phoneNum,
  });
  final String phoneNum;
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName, phoneNum];

  @override
  String toString() {
    return 'Submitted { lastName: $lastName, phoneNum: $phoneNum }';
  }
}
