import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/usecases/send_email_verification.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'verify_email_event.dart';
part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  VerifyEmailBloc({
    @required this.sendEmailVerification,
  }) : assert(sendEmailVerification != null);
  final SendEmailVerification sendEmailVerification;

  @override
  VerifyEmailState get initialState => VerifyEmailState.initial();

  @override
  Stream<VerifyEmailState> mapEventToState(
    VerifyEmailEvent event,
  ) async* {
    if (event is SendVerificationEmail) {
      yield* _mapSendVerificationEmailToState();
    }
  }

  Stream<VerifyEmailState> _mapSendVerificationEmailToState() async* {
    yield VerifyEmailState.sendingVerificationEmail();
    final result = await sendEmailVerification(NoParams());
    yield* result.fold(
      (Failure failure) async* {
        if (failure is SendEmailFailure) {
          yield VerifyEmailState.error(Strings.sendEmailFailureErrorMsg);
        } else if (failure is NetworkFailure) {
          yield VerifyEmailState.error(Strings.networkFailureErrorMsg);
        }
      },
      (r) async* {
        yield VerifyEmailState.sentVerificationEmail();
      },
    );
  }
}
