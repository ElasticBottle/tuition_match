import 'package:equatable/equatable.dart';

abstract class AssignmentCreateEvent extends Equatable {
  const AssignmentCreateEvent();
}

// Updating and Adding assignment
class SetAssignment extends AssignmentCreateEvent {
  const SetAssignment();

  @override
  List<Object> get props => [];
}

class UpdateAssignment extends AssignmentCreateEvent {
  const UpdateAssignment();

  @override
  List<Object> get props => [];
}

class SetCachedAssignment extends AssignmentCreateEvent {
  const SetCachedAssignment();

  @override
  List<Object> get props => [];
}
