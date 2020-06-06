part of 'verify_email_bloc.dart';

class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    this.isSending,
    this.isSent,
    this.isSigningOut,
    this.error,
  });

  factory VerifyEmailState.initial() {
    return VerifyEmailState(
      isSending: false,
      isSent: false,
      isSigningOut: false,
      error: null,
    );
  }
  factory VerifyEmailState.error(String error) {
    return VerifyEmailState(
      isSending: false,
      isSent: false,
      isSigningOut: false,
      error: error,
    );
  }
  factory VerifyEmailState.signingOut() {
    return VerifyEmailState(
      isSending: false,
      isSent: false,
      isSigningOut: true,
      error: null,
    );
  }
  factory VerifyEmailState.sendingVerificationEmail() {
    return VerifyEmailState(
      isSending: true,
      isSent: false,
      isSigningOut: false,
      error: null,
    );
  }
  factory VerifyEmailState.sentVerificationEmail() {
    return VerifyEmailState(
      isSending: false,
      isSent: true,
      isSigningOut: false,
      error: null,
    );
  }
  final bool isSending;
  final bool isSent;
  final bool isSigningOut;
  final String error;

  VerifyEmailState copyWith({
    bool isSending,
    bool isSent,
    bool isSigningOut,
    String error,
  }) {
    return VerifyEmailState(
      isSending: isSending ?? this.isSending,
      isSent: isSent ?? this.isSent,
      isSigningOut: isSigningOut ?? this.isSigningOut,
      error: error,
    );
  }

  @override
  List<Object> get props => [isSending, isSent, isSigningOut, error];

  @override
  String toString() =>
      'VerfiyEmailState { isSending : $isSending, isSent : $isSent, isSigningOut : $isSigningOut, error : $error}';
}

class VerifyEmailInitial extends VerifyEmailState {}
