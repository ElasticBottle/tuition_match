import 'package:equatable/equatable.dart';

abstract class AssignmentsSearchEvent extends Equatable {
  const AssignmentsSearchEvent();
}

// Searching Assignment List
class GetAssignmentsByCriterion extends AssignmentsSearchEvent {
  const GetAssignmentsByCriterion({
    this.level,
    this.subject,
    this.rateMax,
    this.rataMin,
  });
  final int level;
  final int subject;
  final String rateMax;
  final String rataMin;
  @override
  List<Object> get props => [];
}

class GetNextCriterionList extends AssignmentsSearchEvent {
  @override
  List<Object> get props => [];
}

class GetByCachedCriterion extends AssignmentsSearchEvent {
  @override
  List<Object> get props => [];
}

// Deleting Assignment
class DelAssignment extends AssignmentsSearchEvent {
  @override
  List<Object> get props => [];
}

// Updating and Adding assignment
class SetAssignment extends AssignmentsSearchEvent {
  const SetAssignment();

  @override
  List<Object> get props => [];
}

class UpdateAssignment extends AssignmentsSearchEvent {
  const UpdateAssignment();

  @override
  List<Object> get props => [];
}

class SetCachedAssignment extends AssignmentsSearchEvent {
  const SetCachedAssignment();

  @override
  List<Object> get props => [];
}
