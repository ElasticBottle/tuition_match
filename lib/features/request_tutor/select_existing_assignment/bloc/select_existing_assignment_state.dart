part of 'select_existing_assignment_bloc.dart';

abstract class SelectExistingAssignmentState extends Equatable {
  const SelectExistingAssignmentState();
  @override
  List<Object> get props => [];
}

class SelectExistingAssignmentInitial extends SelectExistingAssignmentState {}

class AssignmentsLoaded extends SelectExistingAssignmentState {
  const AssignmentsLoaded({
    this.userAssignmentList,
  });
  final List<TuteeAssignmentModel> userAssignmentList;

  @override
  List<Object> get props => [
        userAssignmentList,
      ];

  @override
  String toString() =>
      'AssignmentsLoaded(userAssignmentList: $userAssignmentList)';
}

class AssignmentSelected extends SelectExistingAssignmentState {}
