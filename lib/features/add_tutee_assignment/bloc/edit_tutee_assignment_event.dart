part of 'edit_tutee_assignment_bloc.dart';

abstract class EditTuteeAssignmentEvent extends Equatable {
  const EditTuteeAssignmentEvent();
  @override
  List<Object> get props => [];
}

class InitialiseEditTuteeFields extends EditTuteeAssignmentEvent {
  const InitialiseEditTuteeFields({
    this.assignment,
    this.userDetails,
  });
  final TuteeAssignmentModel assignment;
  final UserModel userDetails;

  @override
  List<Object> get props => [userDetails, assignment];

  @override
  String toString() {
    return 'InitialiseFields(assignment: $assignment, userDetials: $userDetails )';
  }
}

/// [HandleToggleButtonClick] updates state fields with the latest toggled value(s)
/// Checks if the field is valid.
/// Results in an error state to be yielded if the field is empty
/// Fields are saved if valid. Removed if not
/// To be used by nonTextFields.
class HandleToggleButtonClick extends EditTuteeAssignmentEvent {
  const HandleToggleButtonClick({
    this.index,
    this.fieldName,
  });
  final dynamic index;
  final String fieldName;

  @override
  List<Object> get props => [index, fieldName];

  @override
  String toString() =>
      'HandleToggleButtonClick(index: $index, fieldName : $fieldName)';
}

class HandleTextField extends EditTuteeAssignmentEvent {
  const HandleTextField({this.value, this.fieldName});
  final String value;
  final String fieldName;

  @override
  List<Object> get props => [value, fieldName];

  @override
  String toString() => 'HandleTextField(value: $value, fieldName : $fieldName)';
}

class HandleRates extends EditTuteeAssignmentEvent {
  const HandleRates({this.value, this.fieldName});
  final String value;
  final String fieldName;

  @override
  List<Object> get props => [value, fieldName];

  @override
  String toString() => 'HandleRates(value: $value, fieldName : $fieldName)';
}

class SubmitForm extends EditTuteeAssignmentEvent {}
