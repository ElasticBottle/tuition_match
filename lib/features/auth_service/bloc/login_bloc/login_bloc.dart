import 'dart:async';

import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:cotor/domain/usecases/auth_service/sign_in_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/sign_in_with_goolge.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required this.signInWithEmail,
    @required this.signInWithGoogle,
    @required this.validator,
  });

  final SignInWithEmail signInWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final EmailAndPasswordValidators validator;

  @override
  LoginState get initialState => LoginFormState.initial();

  @override
  Stream<LoginState> transformEvents(
    Stream<LoginEvent> events,
    Stream<LoginState> Function(LoginEvent) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! EmailChanged && event is! PasswordChanged;
    });
    final debounceStream = events.where((event) {
      return event is EmailChanged || event is PasswordChanged;
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGooglePressedToState();
    } else if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentialsPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    final bool isValidEmail = validator.emailSubmitValidator.isValid(email);
    final bool notEmpty = validator.nonEmptyStringValidator.isValid(email);
    if (isValidEmail && notEmpty) {
      yield state.copyWith(
        passwordError: state.passwordError,
        isLoginFailure: false,
      );
    } else {
      yield state.copyWith(
        emailError: Strings.invalidEmailErrorText,
        passwordError: state.passwordError,
        isLoginFailure: false,
      );
    }
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    final bool isValidPassword =
        validator.passwordSignInSubmitValidator.isValid(password);
    if (isValidPassword) {
      yield state.copyWith(
        emailError: state.emailError,
        isLoginFailure: false,
      );
    } else {
      yield state.copyWith(
        emailError: state.emailError,
        passwordError: Strings.invalidPasswordEmpty,
        isLoginFailure: false,
      );
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    yield LoginFormState.submitting();

    final Either<Failure, User> result = await signInWithGoogle(NoParams());
    yield* result.fold(
      (Failure failure) async* {
        final AuthenticationFailure fail = failure;
        yield LoginFormState.failure(fail.message);
      },
      (User user) async* {
        yield LoginFormState.success();
      },
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {String email, String password}) async* {
    yield LoginFormState.submitting();

    final Either<Failure, User> result = await signInWithEmail(
      EmailSignInParams(
        email: email,
        password: password,
      ),
    );

    yield* result.fold(
      (Failure failure) async* {
        final AuthenticationFailure fail = failure;
        yield LoginFormState.failure(fail.message);
      },
      (User user) async* {
        yield LoginFormState.success();
      },
    );
  }
}
