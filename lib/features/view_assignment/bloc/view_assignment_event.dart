part of 'view_assignment_bloc.dart';

abstract class ViewAssignmentEvent extends Equatable {
  const ViewAssignmentEvent();
}

class AssignmentToView extends ViewAssignmentEvent {
  const AssignmentToView({this.assignment});
  final TuteeAssignment assignment;
  @override
  List<Object> get props => [assignment];

  @override
  String toString() => 'AssignmentToView { assignment : $assignment}';
}
