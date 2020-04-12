import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:cotor/features/auth_service/validator.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc({
    @required this.validator,
    @required this.createAccountWithEmail,
  });
  EmailAndPasswordValidators validator;
  CreateAccountWithEmail createAccountWithEmail;
  @override
  RegistrationState get initialState => RegistrationState.empty();

  @override
  Stream<RegistrationState> transformEvents(
    Stream<RegistrationEvent> events,
    Stream<RegistrationState> Function(RegistrationEvent) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! EmailChanged && event is! PasswordChanged;
    });
    final debounceStream = events.where((event) {
      return event is EmailChanged || event is PasswordChanged;
    }).debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
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
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      );
    }
  }

  Stream<RegistrationState> _mapEmailChangedToState(String email) async* {
    final bool isValidEmail = validator.emailSubmitValidator.isValid(email);
    if (isValidEmail) {
      yield state.copyWith();
    } else {
      yield state.copyWith(emailError: Strings.invalidEmailErrorText);
    }
  }

  Stream<RegistrationState> _mapPasswordChangedToState(String password) async* {
    final bool isValidPassword =
        validator.passwordRegisterSubmitValidator.isValid(password);
    if (isValidPassword) {
      yield state.copyWith();
    } else {
      yield state.copyWith(passwordError: Strings.invalidPasswordTooShort);
    }
  }

  Stream<RegistrationState> _mapFirstNameChangedToState(
      String firstName) async* {
    final bool isValidfirstName =
        validator.nonEmptyStringValidator.isValid(firstName);
    if (isValidfirstName) {
      yield state.copyWith();
    } else {
      yield state.copyWith(firstNameError: Strings.invalidFieldCannotBeEmpty);
    }
  }

  Stream<RegistrationState> _mapLastNameChangedToState(String lastName) async* {
    final bool isValidlastName =
        validator.nonEmptyStringValidator.isValid(lastName);
    if (isValidlastName) {
      yield state.copyWith();
    } else {
      yield state.copyWith(lastNameError: Strings.invalidFieldCannotBeEmpty);
    }
  }

  Stream<RegistrationState> _mapFormSubmittedToState({
    String email,
    String password,
    String username,
    String firstName,
    String lastName,
  }) async* {
    yield RegistrationState.loading();
    final Either<Failure, bool> result =
        await createAccountWithEmail(CreateAccountParams(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    ));
    result.fold((Failure failure) async* {
      final AuthenticationFailure fail = failure;
      yield state.copyWith(
        isFailure: true,
        loginError: fail.message,
      );
    }, (r) async* {
      yield RegistrationState.success();
    });
  }
}
