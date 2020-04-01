import 'package:equatable/equatable.dart';

abstract class AssignmentsEvent extends Equatable {
  const AssignmentsEvent();
}

// Retrieving Assignment List
class GetAssignmentList extends AssignmentsEvent {
  @override
  List<Object> get props => [];
}

class GetNextAssignmentList extends AssignmentsEvent {
  @override
  List<Object> get props => [];
}

class GetCachedAssignmentList extends AssignmentsEvent {
  @override
  List<Object> get props => [];
}
