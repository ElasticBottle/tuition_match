import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/auth_service/send_email_verification.dart';
import 'package:cotor/domain/usecases/auth_service/sign_out.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'verify_email_event.dart';
part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  VerifyEmailBloc({
    @required this.sendEmailVerification,
    @required this.signOut,
  })  : assert(sendEmailVerification != null),
        assert(signOut != null);
  final SendEmailVerification sendEmailVerification;
  final SignOut signOut;
  @override
  VerifyEmailState get initialState => VerifyEmailState.initial();

  @override
  Stream<VerifyEmailState> mapEventToState(
    VerifyEmailEvent event,
  ) async* {
    if (event is LogOut) {
      yield* _mapLogOutToState();
    } else if (event is SendVerificationEmail) {
      yield* _mapSendVerificationEmailToState();
    }
  }

  Stream<VerifyEmailState> _mapLogOutToState() async* {
    yield VerifyEmailState.signingOut();
    final result = await signOut(NoParams());
    yield* result.fold(
      (l) async* {
        yield VerifyEmailState.error(Strings.networkFailureErrorMsg);
      },
      (_) async* {
        yield VerifyEmailState.initial();
      },
    );
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
