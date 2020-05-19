import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:equatable/equatable.dart';

part 'view_tutor_profile_event.dart';
part 'view_tutor_profile_state.dart';

class ViewTutorProfileBloc
    extends Bloc<ViewTutorProfileEvent, ViewTutorProfileState> {
  @override
  ViewTutorProfileState get initialState => ViewTutorProfileStateImpl.initial();

  @override
  Stream<ViewTutorProfileState> mapEventToState(
    ViewTutorProfileEvent event,
  ) async* {
    if (event is InitialiseViewTutorProfile) {
      yield* _mapAssignmentToViewToState(event);
    }
  }

  Stream<ViewTutorProfileState> _mapAssignmentToViewToState(
      InitialiseViewTutorProfile event) async* {
    yield ViewTutorProfileStateImpl(
      profile: event.profile ?? TutorProfile(),
      isInNestedScrollView: event.isInNestedScrollView,
      isUser: event.isUser,
    );
  }
}
