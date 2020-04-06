import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:equatable/equatable.dart';

part 'view_assignment_event.dart';
part 'view_assignment_state.dart';

class ViewAssignmentBloc
    extends Bloc<ViewAssignmentEvent, ViewAssignmentState> {
  @override
  ViewAssignmentState get initialState => ViewAssignment();

  @override
  Stream<ViewAssignmentState> mapEventToState(
    ViewAssignmentEvent event,
  ) async* {
    if (event is AssignmentToView) {
      yield* _mapAssignmentToViewToState(event.assignment);
    }
  }

  Stream<ViewAssignmentState> _mapAssignmentToViewToState(
      TuteeAssignment assignment) async* {
    yield ViewAssignment(assignment: assignment);
  }
}
