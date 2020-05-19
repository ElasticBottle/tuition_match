import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user/user_export.dart';
import 'package:cotor/domain/usecases/auth_service/get_current_user.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/usecases/user/user_info/user_profile_stream.dart';
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
  UserProfileState get initialState => UserProfileStateImpl.empty();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is UserEnterHompage) {
      yield* _mapUserEnterHomepageToState();
    } else if (event is RefreshUserProfile) {
      yield* _mapRefreshUserProfileToState(event.user);
    } else if (event is UpdateProfileSuccess) {
      yield* _mapUpdateProfileSuccessToState(event.message);
    } else if (event is CachedProfileToSet) {
      yield* _mapCachedProfileToSet(event.isCache);
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
        userProfilesubscription = userProfileStream(userId.identity.uid).listen(
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
    yield state.copyWith(userProfile: user);
  }

  Stream<UserProfileState> _mapUpdateProfileSuccessToState(
      String message) async* {
    yield state.copyWith(
        updateProfileSuccess: true, updateProfileSuccessMsg: message);
    yield state.copyWith(
        updateProfileSuccess: false, updateProfileSuccessMsg: null);
  }

  Stream<UserProfileState> _mapCachedProfileToSet(bool isCache) async* {
    yield state.copyWith(hasCachedProfile: isCache);
  }

  @override
  Future<void> close() {
    userProfilesubscription?.cancel();
    return super.close();
  }
}
