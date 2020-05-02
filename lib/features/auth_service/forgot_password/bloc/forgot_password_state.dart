part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  bool get isEmailError;
  bool get isSubmitting;
  bool get isFailure;
  bool get isSuccess;
  String get failureMessage;

  bool get isFormValid;

  ForgotPasswordState update({
    bool isEmailError,
  });
  ForgotPasswordState copyWith({
    bool isEmailError,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess,
    String failureMessage,
  });
}

class ForgotPasswordStateImpl extends ForgotPasswordState {
  ForgotPasswordStateImpl({
    bool isEmailError,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
  })  : _isEmailError = isEmailError,
        _isSubmitting = isSubmitting,
        _isSuccess = isSuccess,
        _isFailure = isFailure,
        _failureMessage = failureMessage;

  factory ForgotPasswordStateImpl.empty() {
    return ForgotPasswordStateImpl(
      isEmailError: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: null,
    );
  }

  factory ForgotPasswordStateImpl.submitting() {
    return ForgotPasswordStateImpl(
      isEmailError: false,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      failureMessage: null,
    );
  }

  factory ForgotPasswordStateImpl.failure(String msg) {
    return ForgotPasswordStateImpl(
      isEmailError: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      failureMessage: msg,
    );
  }

  factory ForgotPasswordStateImpl.success() {
    return ForgotPasswordStateImpl(
      isEmailError: false,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      failureMessage: null,
    );
  }

  final bool _isEmailError;

  final bool _isSubmitting;
  final bool _isSuccess;
  final bool _isFailure;
  final String _failureMessage;

  @override
  bool get isEmailError => _isEmailError;
  @override
  bool get isSubmitting => _isSubmitting;
  @override
  bool get isFailure => _isFailure;
  @override
  bool get isSuccess => _isSuccess;
  @override
  String get failureMessage => _failureMessage;

  @override
  bool get isFormValid => !isEmailError;

  @override
  ForgotPasswordState update({
    bool isEmailError,
  }) {
    return copyWith(
      isEmailError: isEmailError,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: null,
    );
  }

  @override
  ForgotPasswordState copyWith({
    bool isEmailError,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
  }) {
    return ForgotPasswordStateImpl(
      isEmailError: isEmailError ?? this.isEmailError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage,
    );
  }

  @override
  List<Object> get props => [
        isEmailError,
        isSubmitting,
        isSuccess,
        isFailure,
        failureMessage,
      ];

  @override
  String toString() {
    return '''ForgotPasswordStateImpl {
      isEmailError: $isEmailError,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      failureMessage: $failureMessage,
    }''';
  }
}
