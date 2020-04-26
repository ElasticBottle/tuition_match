import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/models/user_model.dart';
import 'package:equatable/equatable.dart';

part 'request_tutor_page_event.dart';
part 'request_tutor_page_state.dart';

class RequestTutorPageBloc
    extends Bloc<RequestTutorPageEvent, RequestTutorPageState> {
  RequestTutorPageBloc();
  Map<String, dynamic> tutorProfileInfo;
  UserModel userDetails;

  @override
  RequestTutorPageState get initialState {
    return RequestTutorPageState.initial();
  }

  @override
  Stream<RequestTutorPageState> mapEventToState(
    RequestTutorPageEvent event,
  ) async* {
    if (event is InitialiseProfileFields) {
      yield* _mapInitialiseFieldsToState(
        event.tutorProfile,
        event.userDetails,
      );
    }
  }

  Stream<RequestTutorPageState> _mapInitialiseFieldsToState(
    TutorProfileModel profile,
    UserModel userDetails,
  ) async* {
    // TODO(ElasticBottle): figure out what states to yield
  }
}
