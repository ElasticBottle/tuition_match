part of 'view_assignment_bloc.dart';

abstract class ViewAssignmentState extends Equatable {
  const ViewAssignmentState({this.assignment});
  final TuteeAssignment assignment;
}

class ViewAssignment extends ViewAssignmentState {
  const ViewAssignment({TuteeAssignment assignment})
      : super(assignment: assignment);
  @override
  List<Object> get props => [assignment];

  @override
  String toString() => 'ViewAssignment { assignment : $assignment }';
}
