import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/usecases/auth_service/sign_out.dart';
import 'package:cotor/domain/usecases/user/get_current_user.dart';
import 'package:cotor/domain/usecases/user/get_user_profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'auth_service_event.dart';
part 'auth_service_state.dart';

class AuthServiceBloc extends Bloc<AuthServiceEvent, AuthServiceState> {
  AuthServiceBloc({
    @required this.getCurrentUser,
    @required this.signOut,
  });

  final GetCurrentUser getCurrentUser;
  final SignOut signOut;

  @override
  AuthServiceState get initialState => Uninitialized();

  @override
  Stream<AuthServiceState> mapEventToState(
    AuthServiceEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthServiceState> _mapAppStartedToState() async* {
    final user = await getCurrentUser(NoParams());
    user.fold(
      (l) async* {
        yield Unauthenticated();
      },
      (User r) async* {
        yield Authenticated(
          userProfile: r,
          isEmailVerified: r.isEmailVerified,
        );
      },
    );
  }

  Stream<AuthServiceState> _mapLoggedInToState() async* {
    final user = await getCurrentUser(NoParams());
    user.fold(
      (l) async* {
        yield Unauthenticated();
      },
      (User r) async* {
        yield Authenticated(
          userProfile: r,
          isEmailVerified: r.isEmailVerified,
        );
      },
    );
  }

  Stream<AuthServiceState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    signOut(NoParams());
  }
}
