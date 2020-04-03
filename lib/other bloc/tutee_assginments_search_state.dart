import 'package:equatable/equatable.dart';

abstract class AssignmentsSearchState extends Equatable {
  const AssignmentsSearchState();
}

class InitialAssignmentsSearchState extends AssignmentsSearchState {
  @override
  List<Object> get props => [];
}

class CriterionSearchLoading extends AssignmentsSearchState {
  @override
  List<Object> get props => [];
}

class CriterionSearchLoaded extends AssignmentsSearchState {
  const CriterionSearchLoaded({this.assignments});
  final List<TuteeAssignment> assignments;
  @override
  List<Object> get props => [
        assignments,
      ];
}

class CriterionSearchError extends AssignmentsSearchState {
  const CriterionSearchError({@required this.message});
  final String message;

  @override
  List<Object> get props => [];
}

class NextCriterionSearchLoading extends AssignmentsSearchState {
  @override
  List<Object> get props => [];
}

class NextCriterionSearchLoaded extends AssignmentsSearchState {
  const NextCriterionSearchLoaded({this.assignments});
  final List<TuteeAssignment> assignments;
  @override
  List<Object> get props => [
        assignments,
      ];
}

class NextCriterionSearchError extends AssignmentsSearchState {
  const NextCriterionSearchError({@required this.message});
  final String message;

  @override
  List<Object> get props => [];
}
