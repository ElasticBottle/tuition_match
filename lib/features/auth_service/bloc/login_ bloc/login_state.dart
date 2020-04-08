part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState({
    this.emailError,
    this.passwordError,
    this.isSubmitting,
    this.isLoginSuccess,
    this.isLoginFailure,
    this.hasErrors,
  });
  final String emailError;
  final String passwordError;
  final bool isSubmitting;
  final bool isLoginSuccess;
  final bool isLoginFailure;
  final bool hasErrors;
}

class LoginFormState extends LoginState {
  LoginFormState({
    String emailError,
    String passwordError,
    bool isSubmitting,
    bool isLoginSuccess,
    bool isLoginFailure,
    bool hasErrors,
  }) : super(
          emailError: emailError,
          passwordError: passwordError,
          isSubmitting: isSubmitting,
          isLoginSuccess: isLoginSuccess,
          isLoginFailure: isLoginFailure,
          hasErrors: hasErrors,
        );

  factory LoginFormState.initial() {
    return LoginFormState(
      isSubmitting: false,
      isLoginSuccess: false,
      isLoginFailure: false,
      hasErrors: false,
    );
  }

  LoginFormState copyWith(String emailError, String passwordError,
      bool isSubmitting, bool isLoginSuccess, bool hasErrors) {
    return LoginFormState(
      emailError: emailError,
      passwordError: passwordError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
      hasErrors: hasErrors ?? this.hasErrors,
    );
  }

  @override
  List<Object> get props => [
        emailError,
        passwordError,
        isSubmitting,
        isLoginSuccess,
        isLoginFailure,
        hasErrors,
      ];

  @override
  String toString() => '''LoginFormState {
    emailError : $emailError ,
    passwordError : $passwordError ,
    isSubmitting : $isSubmitting ,
    isLoginSuccess : $isLoginSuccess , 
    isLoginFailure: $isLoginFailure ,
    hasErrors : $hasErrors ,
  }''';
}
