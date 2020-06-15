import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:cotor/features/authentication/domain/usecases/get_current_user.dart';
import 'package:cotor/features/authentication/domain/usecases/is_first_app_launch.dart';
import 'package:cotor/features/authentication/domain/usecases/is_user_profile_created.dart';
import 'package:cotor/features/authentication/domain/usecases/set_is_first_app_launch_false.dart';
import 'package:cotor/features/authentication/domain/usecases/sign_out.dart';
import 'package:cotor/features/authentication/domain/usecases/user_stream.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    @required this.isUserProfileCreated,
    @required this.getCurrentUser,
    @required this.signOut,
    @required this.userStream,
    @required this.isFirstAppLaunch,
    @required this.setIsFirstAppLaunchFalse,
  });

  StreamSubscription userSubscription;
  final IsUserProfileCreated isUserProfileCreated;
  final GetCurrentUser getCurrentUser;
  final UserStream userStream;
  final SignOut signOut;
  final IsFirstAppLaunch isFirstAppLaunch;
  final SetIsFirstAppLaunchFalse setIsFirstAppLaunchFalse;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is FinishOnboarding) {
      yield* _mapFinishOnboardingToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final bool isFirstTime = isFirstAppLaunch();
    if (isFirstTime) {
      yield FirstTimeAppLaunch();
      return;
    }
    userSubscription?.cancel();
    userSubscription = userStream.stream().listen((AuthenticatedUser user) {
      add(LoggedIn());
    });
  }

  Stream<AuthenticationState> _mapFinishOnboardingToState() async* {
    await setIsFirstAppLaunchFalse();
    userSubscription?.cancel();
    userSubscription = userStream.stream().listen((AuthenticatedUser user) {
      add(LoggedIn());
    });
    yield Unauthenticated();
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Uninitialized();
    final user = await getCurrentUser(NoParams());
    yield* user.fold(
      (Failure noLoggedInUser) async* {
        yield Unauthenticated();
      },
      (AuthenticatedUser user) async* {
        // User is logged in, checking to see if the user is in one of three categories:
        // - First time Google sign in
        // - Needs to verify email
        // - Is existing user
        final Either<Failure, bool> databaseProfile =
            await isUserProfileCreated(
                IsUserProfileCreatedParams(uid: user.uid));
        yield* databaseProfile.fold(
          (Failure f) async* {
            if (f is NetworkFailure) {
            } else {
              // serverFailure

            }
            yield Unauthenticated();
          },
          (bool profileMissing) async* {
            if (profileMissing) {
              yield MissingUserInfo();
            } else if (user.isEmailVerified) {
              yield Authenticated(
                userProfile: user,
              );
            } else {
              yield UnverifiedEmail();
            }
          },
        );
      },
    );
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Uninitialized();
    await signOut(NoParams());
    yield Unauthenticated();
  }

  @override
  Future<void> close() {
    userSubscription?.cancel();
    return super.close();
  }
}
