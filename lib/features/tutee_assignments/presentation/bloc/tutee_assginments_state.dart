import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssignmentsState extends Equatable {
  const AssignmentsState();
}

class InitialAssignmentsState extends AssignmentsState {
  @override
  List<Object> get props => [];
}

class AssignmentLoading extends AssignmentsState {
  @override
  List<Object> get props => [];
}

class AssignmentLoaded extends AssignmentsState {
  const AssignmentLoaded({this.assignments});
  final List<TuteeAssignment> assignments;
  @override
  List<Object> get props => [
        assignments,
      ];
}

class AssignmentError extends AssignmentsState {
  const AssignmentError({@required this.message});
  final String message;

  @override
  List<Object> get props => [];
}

class NextAssignmentLoading extends AssignmentsState {
  @override
  List<Object> get props => [];
}

class NextAssignmentLoaded extends AssignmentsState {
  const NextAssignmentLoaded({this.assignments});
  final List<TuteeAssignment> assignments;
  @override
  List<Object> get props => [
        assignments,
      ];
}

class NextAssignmentError extends AssignmentsState {
  const NextAssignmentError({@required this.message});
  final String message;

  @override
  List<Object> get props => [];
}

class CachedAssignmentLoading extends AssignmentsState {
  @override
  List<Object> get props => [];
}

class CachedAssignmentLoaded extends AssignmentsState {
  const CachedAssignmentLoaded({this.assignments});
  final List<TuteeAssignment> assignments;
  @override
  List<Object> get props => [
        assignments,
      ];
}

class CachedAssignmentError extends AssignmentsState {
  const CachedAssignmentError({@required this.message});
  final String message;

  @override
  List<Object> get props => [];
}
