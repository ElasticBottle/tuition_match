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
    bool hasErrors,
  }) {
    return LoginFormState(
      emailError: emailError,
      passwordError: passwordError,
      loginError: loginError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoginFailure: isLoginFailure ?? this.isLoginFailure,
      hasErrors: hasErrors ?? this.hasErrors,
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
    bool hasErrors,
  }) : super(
          emailError: emailError,
          passwordError: passwordError,
          loginError: loginError,
          isSubmitting: isSubmitting,
          isLoginFailure: isLoginFailure,
          hasErrors: hasErrors,
        );

  factory LoginFormState.initial() {
    return LoginFormState(
      isSubmitting: false,
      isLoginFailure: false,
      hasErrors: false,
    );
  }

  @override
  List<Object> get props => [
        emailError,
        passwordError,
        loginError,
        isSubmitting,
        isLoginFailure,
        hasErrors,
      ];

  @override
  String toString() => '''LoginFormState {
    emailError : $emailError ,
    passwordError : $passwordError ,
    loginError : $loginError ,
    isSubmitting : $isSubmitting ,
    isLoginFailure: $isLoginFailure ,
    hasErrors : $hasErrors ,
  }''';
}

class LoginSuccess extends LoginState {
  const LoginSuccess({this.user});
  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoginSuccess { LoginSuccess : $user }';
}

class NewGoogleAccountSetUp extends LoginState {
  const NewGoogleAccountSetUp();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'NewGoogleAccountSetUp {}';
}
