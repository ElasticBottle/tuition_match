part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState({
    this.emailError,
    this.passwordError,
    this.loginError,
    this.isSubmitting,
    this.isLoginFailure,
    this.hasErrors,
  });

  final String emailError;
  final String passwordError;
  final String loginError;
  final bool isSubmitting;
  final bool isLoginFailure;
  final bool hasErrors;

  LoginState copyWith({
    String emailError,
    String passwordError,
    String loginError,
    bool isSubmitting,
    final bool isLoginFailure,
  }) {
    return LoginFormState(
      emailError: emailError,
      passwordError: passwordError,
      loginError: loginError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoginFailure: isLoginFailure ?? this.isLoginFailure,
    );
  }
}

class LoginFormState extends LoginState {
  const LoginFormState({
    String emailError,
    String passwordError,
    String loginError,
    bool isSubmitting,
    bool isLoginFailure,
  }) : super(
          emailError: emailError,
          passwordError: passwordError,
          loginError: loginError,
          isSubmitting: isSubmitting,
          isLoginFailure: isLoginFailure,
        );

  factory LoginFormState.initial() {
    return LoginFormState(
      isSubmitting: false,
      isLoginFailure: false,
    );
  }

  factory LoginFormState.submitting() {
    return LoginFormState(
      isLoginFailure: false,
      isSubmitting: true,
    );
  }

  factory LoginFormState.failure(String message) {
    return LoginFormState(
      isLoginFailure: true,
      isSubmitting: false,
      loginError: message,
    );
  }

  factory LoginFormState.success() {
    return LoginFormState(
      emailError: null,
      loginError: null,
      passwordError: null,
      isSubmitting: false,
      isLoginFailure: false,
    );
  }
  @override
  List<Object> get props => [
        emailError,
        passwordError,
        loginError,
        isSubmitting,
        isLoginFailure,
      ];

  @override
  String toString() => '''LoginFormState {
    emailError : $emailError ,
    passwordError : $passwordError ,
    loginError : $loginError ,
    isSubmitting : $isSubmitting ,
    isLoginFailure: $isLoginFailure ,
  }''';
}
