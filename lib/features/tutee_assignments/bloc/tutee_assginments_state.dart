import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssignmentsState extends Equatable {
  const AssignmentsState();
}

class InitialAssignmentsState extends AssignmentsState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'InitialAssignmentsState';
}

class AssignmentLoading extends AssignmentsState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AssignmentLoading';
}

class AssignmentLoaded extends AssignmentsState {
  const AssignmentLoaded({this.assignments});
  final List<TuteeAssignment> assignments;
  @override
  List<Object> get props => [
        assignments,
      ];

  @override
  String toString() => 'AssignmentLoaded { assignments : $assignments }';
}

class AssignmentError extends AssignmentsState {
  const AssignmentError({@required this.message});
  final String message;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AssignmentError { error: $message }';
}

class NextAssignmentLoading extends AssignmentsState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'NextAssignmentLoading';
}

class NextAssignmentLoaded extends AssignmentsState {
  const NextAssignmentLoaded({this.assignments});
  final List<TuteeAssignment> assignments;
  @override
  List<Object> get props => [
        assignments,
      ];

  @override
  String toString() => 'NextAssignmentLoaded{ assignments : $assignments } ';
}

class NextAssignmentError extends AssignmentsState {
  const NextAssignmentError({@required this.message});
  final String message;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'NextAssignmentError { error: $message }';
}

class CachedAssignmentLoading extends AssignmentsState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'CachedAssignmentLoading';
}

class CachedAssignmentLoaded extends AssignmentsState {
  const CachedAssignmentLoaded({this.assignments});
  final List<TuteeAssignment> assignments;
  @override
  List<Object> get props => [
        assignments,
      ];

  @override
  String toString() => 'CachedAssignmentLoaded { assignments: $assignments }';
}

class CachedAssignmentError extends AssignmentsState {
  const CachedAssignmentError({@required this.message});
  final String message;

  @override
  List<Object> get props => [];

  @override
  String toString() => 'CachedAssignmentError { message : $message }';
}
