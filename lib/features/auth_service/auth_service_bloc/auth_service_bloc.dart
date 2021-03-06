import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/usecases/auth_service/get_current_user.dart';
import 'package:cotor/domain/usecases/auth_service/sign_out.dart';
import 'package:cotor/domain/usecases/auth_service/user_stream.dart';
import 'package:cotor/domain/usecases/is_first_app_launch.dart';
import 'package:cotor/domain/usecases/set_is_first_app_launch_false.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/usecases/user/user_info/get_user_profile.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'auth_service_event.dart';
part 'auth_service_state.dart';

class AuthServiceBloc extends Bloc<AuthServiceEvent, AuthServiceState> {
  AuthServiceBloc({
    @required this.getUserProfile,
    @required this.getCurrentUser,
    @required this.signOut,
    @required this.userStream,
    @required this.isFirstAppLaunch,
    @required this.setIsFirstAppLaunchFalse,
  });

  StreamSubscription userSubscription;
  final GetUserProfile getUserProfile;
  final GetCurrentUser getCurrentUser;
  final UserStream userStream;
  final SignOut signOut;
  final IsFirstAppLaunch isFirstAppLaunch;
  final SetIsFirstAppLaunchFalse setIsFirstAppLaunchFalse;

  @override
  AuthServiceState get initialState => Uninitialized();

  @override
  Stream<AuthServiceState> mapEventToState(
    AuthServiceEvent event,
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

  Stream<AuthServiceState> _mapAppStartedToState() async* {
    final bool isFirstTime = isFirstAppLaunch();
    if (isFirstTime) {
      yield FirstTimeAppLaunch();
      return;
    }
    userSubscription?.cancel();
    userSubscription = userStream.stream().listen((User user) {
      add(LoggedIn());
    });
  }

  Stream<AuthServiceState> _mapFinishOnboardingToState() async* {
    await setIsFirstAppLaunchFalse();
    userSubscription?.cancel();
    userSubscription = userStream.stream().listen((User user) {
      add(LoggedIn());
    });
    yield Unauthenticated();
  }

  Stream<AuthServiceState> _mapLoggedInToState() async* {
    yield Uninitialized();
    final user = await getCurrentUser(NoParams());
    yield* user.fold(
      (Failure noLoggedInUser) async* {
        yield Unauthenticated();
      },
      (User user) async* {
        // User is logged in, checking to see if the user is in one of three categories:
        // - First time Google sign in
        // - Needs to verify email
        // - Is existing user
        final Either<Failure, User> databaseProfile =
            await getUserProfile(GetUserProfileParams(uid: user.identity.uid));
        yield* databaseProfile.fold(
          (Failure noDataBaseProfile) async* {
            if (noDataBaseProfile is NoUserFailure) {
              yield NewGoogleUser();
            } else {
              // TODO(elasticBottle): handle other failure states: no internet, server failure etc.
              yield Unauthenticated();
            }
          },
          (User userProfile) async* {
            if (user.identity.isEmailVerified) {
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

  Stream<AuthServiceState> _mapLoggedOutToState() async* {
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
