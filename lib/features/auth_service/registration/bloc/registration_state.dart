part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  bool get isEmailError;
  bool get isPasswordError;
  bool get isFirstNameError;
  bool get isLastNameError;
  bool get isPhoneNumError;
  bool get isCountryCodeError;
  bool get isSubmitting;
  bool get isFailure;
  bool get isSuccess;
  String get failureMessage;

  bool get isFormValid;

  RegistrationState update({
    bool isEmailError,
    bool isPasswordError,
    bool isFirstNameError,
    bool isLastNameError,
    bool isPhoneNumError,
    bool isCountryCodeError,
  });
  RegistrationState copyWith({
    bool isEmailError,
    bool isPasswordError,
    bool isFirstNameError,
    bool isLastNameError,
    bool isPhoneNumError,
    bool isCountryCodeError,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess,
    String failureMessage,
  });
}

class RegistrationStateImpl extends RegistrationState {
  RegistrationStateImpl({
    bool isEmailError,
    bool isPasswordError,
    bool isFirstNameError,
    bool isLastNameError,
    bool isPhoneNumError,
    bool isCountryCodeError,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
  })  : _isEmailError = isEmailError,
        _isPasswordError = isPasswordError,
        _isFirstNameError = isFirstNameError,
        _isLastNameError = isLastNameError,
        _isPhoneNumError = isPhoneNumError,
        _isCountryCodeError = isCountryCodeError,
        _isSubmitting = isSubmitting,
        _isSuccess = isSuccess,
        _isFailure = isFailure,
        _failureMessage = failureMessage;

  factory RegistrationStateImpl.empty() {
    return RegistrationStateImpl(
      isEmailError: false,
      isPasswordError: false,
      isFirstNameError: false,
      isLastNameError: false,
      isPhoneNumError: false,
      isCountryCodeError: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: null,
    );
  }

  factory RegistrationStateImpl.submitting() {
    return RegistrationStateImpl(
      isEmailError: false,
      isPasswordError: false,
      isFirstNameError: false,
      isLastNameError: false,
      isPhoneNumError: false,
      isCountryCodeError: false,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      failureMessage: null,
    );
  }

  factory RegistrationStateImpl.failure(String msg) {
    return RegistrationStateImpl(
      isEmailError: false,
      isPasswordError: false,
      isFirstNameError: false,
      isLastNameError: false,
      isPhoneNumError: false,
      isCountryCodeError: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      failureMessage: msg,
    );
  }

  factory RegistrationStateImpl.success() {
    return RegistrationStateImpl(
      isEmailError: false,
      isPasswordError: false,
      isFirstNameError: false,
      isLastNameError: false,
      isPhoneNumError: false,
      isCountryCodeError: false,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      failureMessage: null,
    );
  }

  final bool _isEmailError;
  final bool _isPasswordError;
  final bool _isFirstNameError;
  final bool _isLastNameError;
  final bool _isPhoneNumError;
  final bool _isCountryCodeError;
  final bool _isSubmitting;
  final bool _isSuccess;
  final bool _isFailure;
  final String _failureMessage;

  @override
  bool get isEmailError => _isEmailError;
  @override
  bool get isPasswordError => _isPasswordError;
  @override
  bool get isFirstNameError => _isFirstNameError;
  @override
  bool get isLastNameError => _isLastNameError;
  @override
  bool get isPhoneNumError => _isPhoneNumError;
  @override
  bool get isCountryCodeError => _isCountryCodeError;
  @override
  bool get isSubmitting => _isSubmitting;
  @override
  bool get isFailure => _isFailure;
  @override
  bool get isSuccess => _isSuccess;
  @override
  String get failureMessage => _failureMessage;

  @override
  bool get isFormValid =>
      !isEmailError &&
      !isPasswordError &&
      !isFirstNameError &&
      !isLastNameError &&
      !isPhoneNumError;

  @override
  RegistrationState update({
    bool isEmailError,
    bool isPasswordError,
    bool isFirstNameError,
    bool isLastNameError,
    bool isPhoneNumError,
    bool isCountryCodeError,
  }) {
    return copyWith(
      isEmailError: isEmailError,
      isPasswordError: isPasswordError,
      isFirstNameError: isFirstNameError,
      isLastNameError: isLastNameError,
      isPhoneNumError: isPhoneNumError,
      isCountryCodeError: isCountryCodeError,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      failureMessage: null,
    );
  }

  @override
  RegistrationState copyWith({
    bool isEmailError,
    bool isPasswordError,
    bool isFirstNameError,
    bool isLastNameError,
    bool isPhoneNumError,
    bool isCountryCodeError,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    String failureMessage,
  }) {
    return RegistrationStateImpl(
      isEmailError: isEmailError ?? this.isEmailError,
      isPasswordError: isPasswordError ?? this.isPasswordError,
      isFirstNameError: isFirstNameError ?? this.isFirstNameError,
      isLastNameError: isLastNameError ?? this.isLastNameError,
      isPhoneNumError: isPhoneNumError ?? this.isPhoneNumError,
      isCountryCodeError: isCountryCodeError ?? this.isCountryCodeError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      failureMessage: failureMessage,
    );
  }

  @override
  List<Object> get props => [
        isEmailError,
        isPasswordError,
        isFirstNameError,
        isLastNameError,
        isPhoneNumError,
        isCountryCodeError,
        isSubmitting,
        isSuccess,
        isFailure,
        failureMessage,
      ];

  @override
  String toString() {
    return '''RegistrationStateImpl {
      isEmailError: $isEmailError,
      isPasswordError: $isPasswordError,
      isFirstNameError: $isFirstNameError,
      isLastNameError: $isLastNameError,
      isPhoneNumError: $isPhoneNumError,
      isCountryCodeError: $isCountryCodeError,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      failureMessage: $failureMessage,
    }''';
  }
}
