import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/create_user_profile_for_google_sign_in.dart';
import 'package:cotor/domain/usecases/user/get_current_user.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'first_time_google_sign_in_state.dart';
part 'first_time_google_sign_in_event.dart';

class FirstTimeGoogleSignInBloc
    extends Bloc<FirstTimeGoogleSignInEvent, FirstTimeGoogleSignInState> {
  FirstTimeGoogleSignInBloc({
    @required this.validator,
    @required this.createUserProfileForGoogleSignIn,
    @required this.getCurrentUser,
  });
  EmailAndPasswordValidators validator;
  CreateUserProfileForGoogleSignIn createUserProfileForGoogleSignIn;
  GetCurrentUser getCurrentUser;

  @override
  FirstTimeGoogleSignInState get initialState =>
      FirstTimeGoogleSignInState.empty();

  @override
  Stream<Transition<FirstTimeGoogleSignInEvent, FirstTimeGoogleSignInState>>
      transformEvents(Stream<FirstTimeGoogleSignInEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) {
      return event is Submitted;
    });
    final debounceStream = events.where((event) {
      return event is! Submitted;
    }).debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<FirstTimeGoogleSignInState> mapEventToState(
    FirstTimeGoogleSignInEvent event,
  ) async* {
    if (event is PhoneNumChanged) {
      yield* _mapPhoneNumChangedToState(event.phoneNum);
    } else if (event is FirstNameChanged) {
      yield* _mapFirstNameChangedToState(event.firstName);
    } else if (event is LastNameChanged) {
      yield* _mapLastNameChangedToState(event.lastName);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        phoneNum: event.phoneNum,
        firstName: event.firstName,
        lastName: event.lastName,
      );
    }
  }

  Stream<FirstTimeGoogleSignInState> _mapPhoneNumChangedToState(
      String phoneNum) async* {
    final bool isValidPhoneNum = validator.phoneNumValidator.isValid(phoneNum);
    if (isValidPhoneNum) {
      yield state.copyWith();
    } else {
      yield state.copyWith(phoneNumError: Strings.errorPhoneNumInvalid);
    }
  }

  Stream<FirstTimeGoogleSignInState> _mapFirstNameChangedToState(
      String firstName) async* {
    final bool isValidfirstName =
        validator.nonEmptyStringValidator.isValid(firstName);
    if (isValidfirstName) {
      yield state.copyWith();
    } else {
      yield state.copyWith(firstNameError: Strings.errorFieldEmpty);
    }
  }

  Stream<FirstTimeGoogleSignInState> _mapLastNameChangedToState(
      String lastName) async* {
    final bool isValidlastName =
        validator.nonEmptyStringValidator.isValid(lastName);
    if (isValidlastName) {
      yield state.copyWith();
    } else {
      yield state.copyWith(lastNameError: Strings.errorFieldEmpty);
    }
  }

  Stream<FirstTimeGoogleSignInState> _mapFormSubmittedToState({
    String phoneNum,
    String firstName,
    String lastName,
  }) async* {
    yield FirstTimeGoogleSignInState.loading();
    final Either<Failure, void> result =
        await createUserProfileForGoogleSignIn(CreateAccountParams(
      phoneNum: phoneNum,
      firstName: firstName,
      lastName: lastName,
    ));
    yield* result.fold(
      (Failure failure) async* {
        yield FirstTimeGoogleSignInState.failure();
      },
      (r) async* {
        yield FirstTimeGoogleSignInState.success();
      },
    );
  }
}
