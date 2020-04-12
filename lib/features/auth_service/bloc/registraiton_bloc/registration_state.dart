part of 'registration_bloc.dart';

@immutable
class RegistrationState {
  const RegistrationState({
    @required this.emailError,
    @required this.passwordError,
    @required this.firstNameError,
    @required this.lastNameError,
    @required this.loginError,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory RegistrationState.empty() {
    return RegistrationState(
      emailError: null,
      passwordError: null,
      firstNameError: null,
      lastNameError: null,
      loginError: null,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegistrationState.loading() {
    return RegistrationState(
      emailError: null,
      passwordError: null,
      firstNameError: null,
      lastNameError: null,
      loginError: null,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory RegistrationState.failure() {
    return RegistrationState(
      emailError: null,
      passwordError: null,
      firstNameError: null,
      lastNameError: null,
      loginError: Strings.registrationFailed,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory RegistrationState.success() {
    return RegistrationState(
      emailError: null,
      passwordError: null,
      firstNameError: null,
      lastNameError: null,
      loginError: null,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  final String emailError;
  final String passwordError;
  final String firstNameError;
  final String lastNameError;
  final String loginError;

  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid =>
      emailError.isEmpty &&
      passwordError.isEmpty &&
      firstNameError.isEmpty &&
      lastNameError.isEmpty;

  RegistrationState copyWith({
    String emailError,
    String passwordError,
    String firstNameError,
    String lastNameError,
    String loginError,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return RegistrationState(
      emailError: emailError,
      passwordError: passwordError,
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
    return '''RegistrationState {
      emailError: $emailError,
      passwordError: $passwordError,
      firstNameError: $firstNameError,
      lastNameError: $lastNameError,
      loginError: $loginError,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
