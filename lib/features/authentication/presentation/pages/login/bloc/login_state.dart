part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  bool get isEmailError;
  bool get isPasswordError;
  bool get isSubmitting;
  bool get isLoginFailure;
  bool get isLoginSuccess;
  String get failureMessage;
  LoginState update({
    bool isEmailError,
    bool isPasswordError,
  });
  LoginState copyWith({
    bool isEmailError,
    bool isPasswordError,
    bool isSubmitting,
    bool isLoginFailure,
    bool isLoginSuccess,
    String failureMessage,
  });
}

class LoginFormState extends LoginState {
  LoginFormState({
    bool isEmailError,
    bool isPasswordError,
    bool isSubmitting,
    bool isLoginFailure,
    bool isLoginSuccess,
    String failureMessage,
  })  : _isEmailError = isEmailError,
        _isPasswordError = isPasswordError,
        _isSubmitting = isSubmitting,
        _isLoginFailure = isLoginFailure,
        _isLoginSuccess = isLoginSuccess,
        _failureMessage = failureMessage;

  factory LoginFormState.initial() {
    return LoginFormState(
      isEmailError: false,
      isPasswordError: false,
      isSubmitting: false,
      isLoginFailure: false,
      isLoginSuccess: false,
      failureMessage: null,
    );
  }

  factory LoginFormState.submitting() {
    return LoginFormState(
      isEmailError: false,
      isPasswordError: false,
      isSubmitting: true,
      isLoginFailure: false,
      isLoginSuccess: false,
      failureMessage: null,
    );
  }

  factory LoginFormState.failure(String message) {
    return LoginFormState(
      isEmailError: false,
      isPasswordError: false,
      isSubmitting: false,
      isLoginFailure: true,
      isLoginSuccess: false,
      failureMessage: message,
    );
  }

  factory LoginFormState.success() {
    return LoginFormState(
      isEmailError: false,
      isPasswordError: false,
      isSubmitting: false,
      isLoginFailure: false,
      isLoginSuccess: true,
      failureMessage: null,
    );
  }

  final bool _isEmailError;
  final bool _isPasswordError;
  final bool _isSubmitting;
  final bool _isLoginFailure;
  final bool _isLoginSuccess;
  final String _failureMessage;

  @override
  bool get isEmailError => _isEmailError;
  @override
  bool get isPasswordError => _isPasswordError;
  @override
  bool get isSubmitting => _isSubmitting;
  @override
  bool get isLoginFailure => _isLoginFailure;
  @override
  bool get isLoginSuccess => _isLoginSuccess;
  @override
  String get failureMessage => _failureMessage;

  @override
  LoginState update({
    bool isEmailError,
    bool isPasswordError,
  }) {
    return copyWith(
      isEmailError: isEmailError,
      isPasswordError: isPasswordError,
      isSubmitting: false,
      isLoginFailure: false,
      isLoginSuccess: false,
      failureMessage: null,
    );
  }

  @override
  LoginState copyWith({
    bool isEmailError,
    bool isPasswordError,
    bool isSubmitting,
    bool isLoginFailure,
    bool isLoginSuccess,
    String failureMessage,
  }) {
    return LoginFormState(
      isEmailError: isEmailError ?? this.isEmailError,
      isPasswordError: isPasswordError ?? this.isPasswordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoginFailure: isLoginFailure ?? this.isLoginFailure,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      failureMessage: failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object> get props => [
        isEmailError,
        isPasswordError,
        isSubmitting,
        isLoginFailure,
        isLoginSuccess,
        failureMessage,
      ];

  @override
  String toString() => '''LoginFormState {
      isEmailError: $isEmailError,
      isPasswordError: $isPasswordError,
      isSubmitting: $isSubmitting,
      isLoginFailure: $isLoginFailure,
      isLoginSuccess: $isLoginSuccess,
      failureMessage: $failureMessage,
  }''';
}
