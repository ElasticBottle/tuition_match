part of 'add_tutee_assignment_bloc.dart';

abstract class AddTuteeAssignmentState extends Equatable {
  const AddTuteeAssignmentState();
}

class AddTuteeAssignmentInitial extends AddTuteeAssignmentState {
  const AddTuteeAssignmentInitial();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AddTuteeAssignmentInitial';
}

class Loading extends AddTuteeAssignmentState {
  const Loading();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loading { }';
}

class Loaded extends AddTuteeAssignmentState {
  const Loaded();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Loaded { }';
}
