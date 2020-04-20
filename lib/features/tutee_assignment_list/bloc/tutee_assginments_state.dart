import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AssignmentsState extends Equatable {
  const AssignmentsState();
}

class Loading extends AssignmentsState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'InitialAssignmentsState';
}

class AssignmentLoaded extends AssignmentsState {
  const AssignmentLoaded({
    this.assignments,
    this.isFetching,
    this.isEnd,
    this.isCachedList,
  });
  final List<TuteeAssignmentModel> assignments;
  final bool isFetching;
  final bool isEnd;
  final bool isCachedList;

  AssignmentLoaded copyWith({
    List<TuteeAssignmentModel> assignments,
    bool isFetching,
    bool isEnd,
    bool isCachedList,
  }) {
    return AssignmentLoaded(
      assignments: assignments ?? this.assignments,
      isFetching: isFetching ?? this.isFetching,
      isEnd: isEnd ?? this.isEnd,
      isCachedList: isCachedList ?? this.isCachedList,
    );
  }

  @override
  List<Object> get props => [
        assignments,
        isFetching,
        isEnd,
      ];

  @override
  String toString() => '''AssignmentLoaded {
     assignments : $assignments 
     isFetching: $isFetching
     isEnd: $isEnd
     isCachedList : $isCachedList
     }''';
}

class AssignmentError extends AssignmentsState {
  const AssignmentError({@required this.message});
  final String message;

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'AssignmentError { error: $message }';
}

class CachedAssignmentError extends AssignmentsState {
  const CachedAssignmentError({@required this.message});
  final String message;

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'CachedAssignmentError { message : $message }';
}
