import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'registration_event.dart';
part 'registration_state.dart';

const int REGISTRATION_BLOC_DEBOUNCE_TIME = 300;

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({
    @required this.validator,
    @required this.createAccountWithEmail,
  })  : assert(validator != null),
        assert(createAccountWithEmail != null);
  final EmailAndPasswordValidators validator;
  final CreateAccountWithEmail createAccountWithEmail;

  @override
  RegistrationState get initialState => RegistrationStateImpl.empty();

  @override
  Stream<Transition<RegistrationEvent, RegistrationState>> transformEvents(
      Stream<RegistrationEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) {
      return event is! EmailChanged && event is! PasswordChanged;
    });
    final debounceStream = events.where((event) {
      return event is EmailChanged || event is PasswordChanged;
    }).debounceTime(Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is FirstNameChanged) {
      yield* _mapFirstNameChangedToState(event.firstName);
    } else if (event is LastNameChanged) {
      yield* _mapLastNameChangedToState(event.lastName);
    } else if (event is PhoneNumChanged) {
      yield* _mapPhoneNumChangedToState(event.phoneNum);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNum: event.phoneNum,
      );
    }
  }

  Stream<RegistrationState> _mapEmailChangedToState(String email) async* {
    print(email);
    final bool isValidEmail =
        validator.emailRegistrationValidator.isValid(email);
    if (isValidEmail) {
      yield state.update(
        isEmailError: false,
      );
    } else {
      yield state.update(
        isEmailError: true,
      );
    }
  }

  Stream<RegistrationState> _mapPasswordChangedToState(String password) async* {
    final bool isValidPassword =
        validator.passwordRegistrationValidator.isValid(password);
    if (isValidPassword) {
      yield state.update(
        isPasswordError: false,
      );
    } else {
      yield state.update(
        isPasswordError: true,
      );
    }
  }

  Stream<RegistrationState> _mapFirstNameChangedToState(
      String firstName) async* {
    final bool isValidfirstName =
        validator.nonEmptyStringValidator.isValid(firstName);
    if (isValidfirstName) {
      yield state.update(
        isFirstNameError: false,
      );
    } else {
      yield state.update(
        isFirstNameError: true,
      );
    }
  }

  Stream<RegistrationState> _mapLastNameChangedToState(String lastName) async* {
    final bool isValidlastName =
        validator.nonEmptyStringValidator.isValid(lastName);
    if (isValidlastName) {
      yield state.update(
        isLastNameError: false,
      );
    } else {
      yield state.update(
        isLastNameError: true,
      );
    }
  }

  Stream<RegistrationState> _mapPhoneNumChangedToState(String phoneNum) async* {
    final bool isValidPhoneNum = validator.phoneNumValidator.isValid(phoneNum);
    if (isValidPhoneNum) {
      yield state.update(
        isPhoneNumError: false,
      );
    } else {
      yield state.update(
        isPhoneNumError: true,
      );
    }
  }

  Stream<RegistrationState> _mapFormSubmittedToState({
    String email,
    String password,
    String username,
    String firstName,
    String lastName,
    String phoneNum,
  }) async* {
    yield RegistrationStateImpl.submitting();
    final Either<Failure, bool> result =
        await createAccountWithEmail(CreateAccountParams(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNum: phoneNum,
    ));
    result.fold((Failure failure) async* {
      final AuthenticationFailure fail = failure;
      yield RegistrationStateImpl.failure(fail.message);
    }, (r) async* {
      yield RegistrationStateImpl.success();
    });
  }
}
