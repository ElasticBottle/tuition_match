part of 'verify_email_bloc.dart';

class VerifyEmailState extends Equatable {
  const VerifyEmailState({
    this.isSending,
    this.isSent,
    this.error,
  });

  factory VerifyEmailState.initial() {
    return VerifyEmailState(
      isSending: false,
      isSent: false,
      error: null,
    );
  }
  factory VerifyEmailState.error(String error) {
    return VerifyEmailState(
      isSending: false,
      isSent: false,
      error: error,
    );
  }
  factory VerifyEmailState.sendingVerificationEmail() {
    return VerifyEmailState(
      isSending: true,
      isSent: false,
      error: null,
    );
  }
  factory VerifyEmailState.sentVerificationEmail() {
    return VerifyEmailState(
      isSending: false,
      isSent: true,
      error: null,
    );
  }
  final bool isSending;
  final bool isSent;
  final String error;

  VerifyEmailState copyWith({
    bool isSending,
    bool isSent,
    String error,
  }) {
    return VerifyEmailState(
      isSending: isSending ?? this.isSending,
      isSent: isSent ?? this.isSent,
      error: error,
    );
  }

  @override
  List<Object> get props => [isSending, isSent, error];

  @override
  String toString() =>
      'VerifyEmailState { isSending : $isSending, isSent : $isSent, error : $error}';
}

class VerifyEmailInitial extends VerifyEmailState {}
