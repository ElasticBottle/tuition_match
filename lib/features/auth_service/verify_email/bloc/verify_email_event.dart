part of 'verify_email_bloc.dart';

abstract class VerifyEmailEvent extends Equatable {
  const VerifyEmailEvent();

  @override
  List<Object> get props => [];
}

class SendVerificationEmail extends VerifyEmailEvent {}

class LogOut extends VerifyEmailEvent {}

class EmailVerified extends VerifyEmailEvent {}
