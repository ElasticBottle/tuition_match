import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/models/user_model.dart';
import 'package:cotor/features/request_tutor/request_tutor_form/bloc/request_tutor_form_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'select_existing_assignment_event.dart';
part 'select_existing_assignment_state.dart';

class SelectExistingAssignmentBloc
    extends Bloc<SelectExistingAssignmentEvent, SelectExistingAssignmentState> {
  SelectExistingAssignmentBloc();

  TutorProfileModel requestingProfile;
  UserModel userDetails;
  @override
  SelectExistingAssignmentState get initialState =>
      SelectExistingAssignmentInitial();

  @override
  Stream<SelectExistingAssignmentState> mapEventToState(
    SelectExistingAssignmentEvent event,
  ) async* {
    if (event is InitialiseAssignmentsToSelect) {
      yield* _mapIntialiseAssignmentsToSelectToState(
          event.requestingProfile, event.userDetails);
    }
    if (event is SelectedAssignment) {
      yield* _mapSelectedAssignemntToState(
        event.isNew,
        event.selectedAssignment,
        event.context,
      );
    }
  }

  Stream<SelectExistingAssignmentState> _mapIntialiseAssignmentsToSelectToState(
      TutorProfileModel requestingProfile, UserModel userDetails) async* {
    this.requestingProfile = requestingProfile;
    this.userDetails = userDetails;
    userDetails.userAssignments.removeWhere((key, value) => !value.isOpen);
    yield AssignmentsLoaded(
      userAssignmentList: userDetails.userAssignments.values.toList(),
    );
  }

  Stream<SelectExistingAssignmentState> _mapSelectedAssignemntToState(
    bool isNew,
    TuteeAssignmentModel userRefAssignment,
    BuildContext context,
  ) async* {
    if (isNew) {
      BlocProvider.of<RequestTutorFormBloc>(context)
          .add(InitialiseRequestProfileFields(
        requestingProfile: requestingProfile,
        userDetails: userDetails,
        userRefAssignment: TuteeAssignmentModel(),
      ));
    } else {
      BlocProvider.of<RequestTutorFormBloc>(context)
          .add(InitialiseRequestProfileFields(
        requestingProfile: requestingProfile,
        userDetails: userDetails,
        userRefAssignment: userRefAssignment,
      ));
    }
    yield AssignmentSelected();
  }
}
