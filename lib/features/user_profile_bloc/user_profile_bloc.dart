import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/domain/entities/user/user_export.dart';
import 'package:cotor/domain/usecases/auth_service/get_current_user.dart';
import 'package:cotor/domain/usecases/user/user_info/user_profile_stream.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    @required this.userProfileStream,
  });
  final UserProfileStream userProfileStream;
  StreamSubscription userProfileSubscription;

  @override
  UserProfileState get initialState => UserProfileStateImpl.empty();

  @override
  Stream<UserProfileState> mapEventToState(
    UserProfileEvent event,
  ) async* {
    if (event is UserEnterHompage) {
      yield* _mapUserEnterHomepageToState(event.uid);
    } else if (event is RefreshUserProfile) {
      yield* _mapRefreshUserProfileToState(event.user);
    } else if (event is UpdateProfileSuccess) {
      yield* _mapUpdateProfileSuccessToState(event.message);
    } else if (event is CachedProfileToSet) {
      yield* _mapCachedProfileToSet(event.isCache);
    }
  }

  Stream<UserProfileState> _mapUserEnterHomepageToState(String uid) async* {
    userProfileSubscription?.cancel();
    userProfileSubscription = userProfileStream(uid).listen(
      (User userProfile) {
        print('user got');
        add(RefreshUserProfile(user: userProfile));
      },
      onError: (dynamic error) {
        print(error.toString());
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
    userProfileSubscription?.cancel();
    return super.close();
  }
}
