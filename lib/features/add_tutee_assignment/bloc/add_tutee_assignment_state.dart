part of 'add_tutee_assignment_bloc.dart';

abstract class AddTuteeAssignmentState extends Equatable {
  const AddTuteeAssignmentState();
}

class AddTuteeAssignmentInitial extends AddTuteeAssignmentState {
  const AddTuteeAssignmentInitial({this.level});
  final List<String> level;

  @override
  List<Object> get props => [level];

  @override
  String toString() => 'AddTuteeAssignmentInitial { level : $level }';
}

class SubjectLoaded extends AddTuteeAssignmentState {
  const SubjectLoaded({
    this.subjects,
  });
  final List<String> subjects;

  @override
  List<Object> get props => [subjects];

  @override
  String toString() => 'SubjectLoaded { subjects : $subjects }';
}
