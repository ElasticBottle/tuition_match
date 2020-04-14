import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/usecases/user/get_current_user.dart';
import 'package:cotor/domain/usecases/user/user_profile_stream.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    @required this.getCurrentUser,
    @required this.userProfileStream,
  });
  final GetCurrentUser getCurrentUser;
  final UserProfileStream userProfileStream;
  StreamSubscription userProfilesubscription;

  @override
  UserProfileState get initialState => UserProfileState.empty();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is UserEnterHompage) {
      yield* _mapUserEnterHomepageToState();
    } else if (event is AddUserAssignment) {
    } else if (event is DelUserAssignment) {
    } else if (event is UpdateUserAssignment) {
    } else if (event is AddUserProfile) {
    } else if (event is UpdateUserProfile) {
    } else if (event is AddProfilePhoto) {
    } else if (event is RefreshUserProfile) {
      yield* _mapRefreshUserProfileToState(event.user);
    }
  }

  Stream<UserProfileState> _mapUserEnterHomepageToState() async* {
    userProfilesubscription?.cancel();
    final Either<Failure, User> userId = await getCurrentUser(NoParams());
    yield* userId.fold(
      (Failure failure) async* {
        print(failure.toString());
      },
      (User userId) async* {
        userProfilesubscription = userProfileStream(userId.uid).listen(
          (User userProfile) {
            add(RefreshUserProfile(user: userProfile));
          },
          onError: (dynamic error) {
            print(error.toString());
          },
        );
      },
    );
  }

  Stream<UserProfileState> _mapRefreshUserProfileToState(User user) async* {
    yield UserProfileState(userProfile: user);
  }

  @override
  Future<void> close() {
    userProfilesubscription?.cancel();
    return super.close();
  }
}
