import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/models/user_model.dart';
import 'package:equatable/equatable.dart';

part 'view_tutor_profile_event.dart';
part 'view_tutor_profile_state.dart';

class ViewTutorProfileBloc
    extends Bloc<ViewTutorProfileEvent, ViewTutorProfileState> {
  @override
  ViewTutorProfileState get initialState => ViewTutorProfileStateImpl();

  @override
  Stream<ViewTutorProfileState> mapEventToState(
    ViewTutorProfileEvent event,
  ) async* {
    if (event is ViewProfile) {
      yield* _mapAssignmentToViewToState(event.profile);
    }
  }

  Stream<ViewTutorProfileState> _mapAssignmentToViewToState(
      TutorProfileModel profile) async* {
    yield ViewTutorProfileStateImpl(profile: profile);
  }
}
