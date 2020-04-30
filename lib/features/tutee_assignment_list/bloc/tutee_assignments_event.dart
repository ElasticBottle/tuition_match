part of 'tutee_assignments_bloc.dart';

abstract class AssignmentsEvent extends Equatable {
  const AssignmentsEvent();
  @override
  List<Object> get props => [];
}

// Retrieving Assignment List
class GetAssignmentList extends AssignmentsEvent {
  @override
  String toString() => 'GetAssignmentList';
}

class GetNextAssignmentList extends AssignmentsEvent {
  @override
  String toString() => 'GetNextAssignmentList';
}

class GetCachedAssignmentList extends AssignmentsEvent {
  @override
  String toString() => 'GetCachedAssignmentList';
}
