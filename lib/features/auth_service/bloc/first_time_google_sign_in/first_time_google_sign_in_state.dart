part of 'first_time_google_sign_in_bloc.dart';

@immutable
class FirstTimeGoogleSignInState {
  const FirstTimeGoogleSignInState({
    @required this.phoneNumError,
    @required this.firstNameError,
    @required this.lastNameError,
    @required this.loginError,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory FirstTimeGoogleSignInState.empty() {
    return FirstTimeGoogleSignInState(
      phoneNumError: null,
      firstNameError: null,
      lastNameError: null,
      loginError: null,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory FirstTimeGoogleSignInState.loading() {
    return FirstTimeGoogleSignInState(
      phoneNumError: null,
      firstNameError: null,
      lastNameError: null,
      loginError: null,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory FirstTimeGoogleSignInState.failure() {
    return FirstTimeGoogleSignInState(
      phoneNumError: null,
      firstNameError: null,
      lastNameError: null,
      loginError: Strings.cannotSaveNameAndPhoneNumber,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory FirstTimeGoogleSignInState.success() {
    return FirstTimeGoogleSignInState(
      phoneNumError: null,
      firstNameError: null,
      lastNameError: null,
      loginError: null,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  final String phoneNumError;
  final String firstNameError;
  final String lastNameError;
  final String loginError;

  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid =>
      phoneNumError == null && firstNameError == null && lastNameError == null;

  FirstTimeGoogleSignInState copyWith({
    String emailError,
    String phoneNumError,
    String firstNameError,
    String lastNameError,
    String loginError,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return FirstTimeGoogleSignInState(
      phoneNumError: phoneNumError,
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      loginError: loginError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''FirstTimeGoogleSignInState {
      phoneNumError: $phoneNumError,
      firstNameError: $firstNameError,
      lastNameError: $lastNameError,
      loginError: $loginError,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
