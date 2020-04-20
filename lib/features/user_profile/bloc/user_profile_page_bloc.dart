import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/features/models/user_model.dart';
import 'package:equatable/equatable.dart';

part 'user_profile_page_event.dart';
part 'user_profile_page_state.dart';

class UserProfilePageBloc
    extends Bloc<UserProfilePageEvent, UserProfilePageState> {
  @override
  UserProfilePageState get initialState => UserProfilePageStateImpl.initial();

  @override
  Stream<UserProfilePageState> mapEventToState(
    UserProfilePageEvent event,
  ) async* {
    if (event is InitialiseUserProfilePage) {
      yield* _mapInitialiseUserProfilePageToState(event.userModel);
    }
  }

  Stream<UserProfilePageState> _mapInitialiseUserProfilePageToState(
      UserModel userModel) async* {
    yield state.copyWith(userModel);
  }
}
