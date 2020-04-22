import 'dart:async';

import 'package:bloc/bloc.dart';
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
  ) async* {}
}
