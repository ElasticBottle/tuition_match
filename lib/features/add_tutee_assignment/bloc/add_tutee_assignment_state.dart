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

class SubmissionLoading extends AddTuteeAssignmentState {
  const SubmissionLoading();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SubmissionLoading { }';
}

class SubmissionError extends AddTuteeAssignmentState {
  const SubmissionError({this.error});
  final FormError error;
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SubmissionError { error : ${error.toString()} }';
}

class SubmissionSuccess extends AddTuteeAssignmentState {
  const SubmissionSuccess();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'SubmissionSuccess { }';
}
