import 'dart:async';

import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/features/auth_service/bloc/auth_service_bloc/auth_service_bloc.dart';
import 'package:cotor/features/auth_service/validator.dart';
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
    this.signInWithEmail,
    this.signInWithGoogle,
    this.validator,
    this.authServiceBloc,
  });

  SignInWithEmail signInWithEmail;
  SignInWithGoogle signInWithGoogle;
  EmailAndPasswordValidators validator;
  AuthServiceBloc authServiceBloc;

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
    if (isValidEmail) {
      yield state.copyWith(
        hasErrors: false,
      );
    } else {
      yield state.copyWith(
          hasErrors: true, emailError: Strings.invalidEmailErrorText);
    }
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    final bool isValidPassword =
        validator.passwordSignInSubmitValidator.isValid(password);
    if (isValidPassword) {
      yield state.copyWith(hasErrors: false);
    } else {
      yield state.copyWith(
          hasErrors: true, passwordError: Strings.invalidPasswordEmpty);
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    yield state.copyWith(
      isSubmitting: true,
    );
    final Either<Failure, User> result = await signInWithGoogle(NoParams());
    result.fold((l) async* {
      yield state.copyWith(
          isLoginFailure: true, loginError: Strings.signInFailed);
    }, (r) async* {
      yield LoginSuccess(user: r);
    });
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password,
  }) async* {
    yield state.copyWith(
      isSubmitting: true,
    );
    final Either<Failure, User> result = await signInWithEmail(
        EmailSignInParams(email: email, password: password));
    result.fold((l) async* {
      yield state.copyWith(
          isLoginFailure: true, loginError: Strings.signInFailed);
    }, (r) async* {
      yield LoginSuccess(user: r);
    });
  }
}
