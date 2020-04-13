import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/usecases/auth_service/send_email_verification.dart';
import 'package:cotor/domain/usecases/auth_service/sign_out.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'verify_email_event.dart';
part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  VerifyEmailBloc({
    @required this.sendEmailVerification,
    @required this.signOut,
  });
  final SendEmailVerification sendEmailVerification;
  final SignOut signOut;
  @override
  VerifyEmailState get initialState => VerifyEmailState(
        isSending: false,
        isSent: false,
        isSigningOut: false,
      );

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
    await signOut(NoParams());
  }

  Stream<VerifyEmailState> _mapSendVerificationEmailToState() async* {
    yield state.copyWith(isSending: true);
    final result = await sendEmailVerification(NoParams());
    yield* result.fold(
      (Failure failure) async* {
        yield VerifyEmailState.error('something went wrong');
      },
      (r) async* {
        yield VerifyEmailState.sentVerificationEmail();
      },
    );
  }
}
