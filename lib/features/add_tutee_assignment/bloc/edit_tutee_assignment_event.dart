part of 'edit_tutee_assignment_bloc.dart';

abstract class EditTuteeAssignmentEvent extends Equatable {
  const EditTuteeAssignmentEvent();
  @override
  List<Object> get props => [];
}

class CheckRatesAreValid extends EditTuteeAssignmentEvent {
  const CheckRatesAreValid({
    @required this.fieldName,
    @required this.toCheck,
  });
  final String toCheck;
  final String fieldName;

  @override
  List<Object> get props => [toCheck, fieldName];

  @override
  String toString() =>
      'CheckRatesAreValid(toCheck: $toCheck, fieldName: $fieldName)';
}

class CheckTextFieldNotEmpty extends EditTuteeAssignmentEvent {
  const CheckTextFieldNotEmpty({
    @required this.fieldName,
    @required this.toCheck,
  });
  final String toCheck;
  final String fieldName;
  @override
  List<Object> get props => [toCheck, fieldName];

  @override
  String toString() =>
      'CheckTextFieldNotEmpty(toCheck: $toCheck, fieldName: $fieldName)';
}

class CheckDropDownNotEmpty extends EditTuteeAssignmentEvent {
  const CheckDropDownNotEmpty({@required this.fieldName});
  final String fieldName;

  @override
  List<Object> get props => [fieldName];

  @override
  String toString() => 'CheckDropDownNotEmpty(fieldName: $fieldName)';
}

class HandleToggleButtonClick extends EditTuteeAssignmentEvent {
  const HandleToggleButtonClick({this.index, this.fieldName});
  final dynamic index;
  final String fieldName;

  @override
  List<Object> get props => [index, fieldName];

  @override
  String toString() =>
      'HandleToggleButtonClick(index: $index, fieldName : $fieldName)';
}

class SaveField extends EditTuteeAssignmentEvent {
  const SaveField({this.key, this.value});
  final String key;
  final dynamic value;

  @override
  List<Object> get props => [key, value];

  @override
  String toString() => 'SaveField(key: $key, value: $value)';
}

class SubmitForm extends EditTuteeAssignmentEvent {}

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
