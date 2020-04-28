part of 'select_existing_assignment_bloc.dart';

abstract class SelectExistingAssignmentEvent extends Equatable {
  const SelectExistingAssignmentEvent();
}

class InitialiseAssignmentsToSelect extends SelectExistingAssignmentEvent {
  const InitialiseAssignmentsToSelect({
    this.requestingProfile,
    this.userDetails,
  });
  final TutorProfileModel requestingProfile;
  final UserModel userDetails;

  @override
  List<Object> get props => [
        userDetails,
        requestingProfile,
      ];

  @override
  String toString() =>
      'InitialiseAssignmentsToSelect(requestingProfile: $requestingProfile, userDetails: $userDetails)';
}

class SelectedAssignment extends SelectExistingAssignmentEvent {
  const SelectedAssignment({
    this.isNew,
    this.selectedAssignment,
    this.context,
  });
  final bool isNew;
  final TuteeAssignmentModel selectedAssignment;
  final BuildContext context;
  @override
  List<Object> get props => [isNew, selectedAssignment, context];

  @override
  String toString() =>
      'SelectedAssignment(isNew: $isNew, selectedAssignment: $selectedAssignment, context: $context)';
}
