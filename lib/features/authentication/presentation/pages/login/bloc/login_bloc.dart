import 'dart:async';

import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:cotor/features/authentication/domain/usecases/sign_in_with_email.dart';
import 'package:cotor/features/authentication/domain/usecases/sign_in_with_google.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

const int DEBOUNCE_TIME = 300;

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    @required this.signInWithEmail,
    @required this.signInWithGoogle,
    @required this.validator,
  })  : assert(signInWithEmail != null),
        assert(signInWithGoogle != null),
        assert(validator != null);

  final SignInWithEmail signInWithEmail;
  final SignInWithGoogle signInWithGoogle;
  final EmailAndPasswordValidators validator;

  @override
  LoginState get initialState => LoginFormState.initial();

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) {
      return event is! EmailChanged && event is! PasswordChanged;
    });
    final debounceStream = events.where((event) {
      return event is EmailChanged || event is PasswordChanged;
    }).debounceTime(Duration(milliseconds: DEBOUNCE_TIME));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
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
    final bool notEmpty = validator.nonEmptyStringValidator.isValid(email);
    if (notEmpty) {
      yield state.update(
        isEmailError: false,
      );
    } else {
      yield state.update(
        isEmailError: true,
      );
    }
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    final bool isValidPassword =
        validator.nonEmptyStringValidator.isValid(password);
    if (isValidPassword) {
      yield state.copyWith(
        isPasswordError: false,
      );
    } else {
      yield state.copyWith(
        isPasswordError: true,
      );
    }
  }

  Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
    yield LoginFormState.submitting();
    final Either<Failure, AuthenticatedUser> result =
        await signInWithGoogle(NoParams());
    yield* result.fold(
      (Failure failure) async* {
        yield LoginFormState.failure(_mapFailureToMessage(failure));
      },
      (AuthenticatedUser user) async* {
        yield LoginFormState.success();
      },
    );
  }

  Stream<LoginState> _mapLoginWithCredentialsPressedToState(
      {String email, String password}) async* {
    yield LoginFormState.submitting();

    final Either<Failure, AuthenticatedUser> result = await signInWithEmail(
      SignInWithEmailParams(
        email: email,
        password: password,
      ),
    );

    yield* result.fold(
      (Failure failure) async* {
        yield LoginFormState.failure(_mapFailureToMessage(failure));
      },
      (AuthenticatedUser user) async* {
        yield LoginFormState.success();
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthenticationFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return Strings.networkFailureErrorMsg;
    } else {
      return Strings.unknownFailureErrorMsg;
    }
  }
}
