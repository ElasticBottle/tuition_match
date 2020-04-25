import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_tutor_page_event.dart';
part 'request_tutor_page_state.dart';

class RequestTutorPageBloc extends Bloc<RequestTutorPageEvent, RequestTutorPageState> {
  @override
  RequestTutorPageState get initialState => RequestTutorPageInitial();

  @override
  Stream<RequestTutorPageState> mapEventToState(
    RequestTutorPageEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
