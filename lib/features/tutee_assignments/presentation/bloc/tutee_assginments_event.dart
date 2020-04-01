import 'package:equatable/equatable.dart';

abstract class AssignmentsEvent extends Equatable {
  const AssignmentsEvent();
}

// Retrieving Assignment List
class GetAssignmentList extends AssignmentsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetAssignmentList';
}

class GetNextAssignmentList extends AssignmentsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetNextAssignmentList';
}

class GetCachedAssignmentList extends AssignmentsEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetCachedAssignmentList';
}
