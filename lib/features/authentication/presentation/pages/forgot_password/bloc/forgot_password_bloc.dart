import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/features/authentication/domain/usecases/forget_password.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

const int FORGOT_PASSWORD_BLOC_DEBOUNCE_TIME = 300;

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    @required this.validator,
    @required this.forgotPassword,
  })  : assert(validator != null),
        assert(forgotPassword != null);
  final EmailAndPasswordValidators validator;
  final ForgotPassword forgotPassword;

  @override
  ForgotPasswordState get initialState => ForgotPasswordStateImpl.empty();

  @override
  Stream<Transition<ForgotPasswordEvent, ForgotPasswordState>> transformEvents(
      Stream<ForgotPasswordEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) {
      return event is! EmailChanged;
    });
    final debounceStream = events.where((event) {
      return event is EmailChanged;
    }).debounceTime(Duration(milliseconds: FORGOT_PASSWORD_BLOC_DEBOUNCE_TIME));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        email: event.email,
      );
    }
  }

  Stream<ForgotPasswordState> _mapEmailChangedToState(String email) async* {
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

  Stream<ForgotPasswordState> _mapFormSubmittedToState({
    String email,
  }) async* {
    yield ForgotPasswordStateImpl.submitting();
    final Either<Failure, bool> result =
        await forgotPassword(ForgotPasswordParams(email: email));
    yield* result.fold(
      (Failure failure) async* {
        yield ForgotPasswordStateImpl.failure(_mapFailureToMsg(failure));
      },
      (r) async* {
        yield ForgotPasswordStateImpl.success();
      },
    );
  }

  String _mapFailureToMsg(Failure failure) {
    if (failure is AuthenticationFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return Strings.networkFailureErrorMsg;
    } else {
      return Strings.unknownFailureErrorMsg;
    }
  }
}
