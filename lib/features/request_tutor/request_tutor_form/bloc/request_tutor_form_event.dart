part of 'request_tutor_form_bloc.dart';

abstract class RequestTutorFormEvent extends Equatable {
  const RequestTutorFormEvent();

  @override
  List<Object> get props => [];
}

class InitialiseProfileFields extends RequestTutorFormEvent {
  const InitialiseProfileFields({
    this.requestingProfile,
    this.userRefAssignment,
    this.userDetails,
  });
  final TutorProfileModel requestingProfile;
  final TuteeAssignmentModel userRefAssignment;
  final UserModel userDetails;

  @override
  List<Object> get props => [
        requestingProfile,
        userRefAssignment,
        userDetails,
      ];

  @override
  String toString() =>
      'InitialiseProfileFields(requestingProfile: $requestingProfile, userRefAssignment: $userRefAssignment, userDetails: $userDetails)';
}

/// [HandleToggleButtonClick] should be called before [CheckDropDownNotEmpty] or [SaveField].
/// Updates state fields with the latest toggled value(s)
/// To be used by nonTextFields.
class HandleToggleButtonClick extends RequestTutorFormEvent {
  const HandleToggleButtonClick({this.index, this.fieldName});
  final dynamic index;
  final String fieldName;

  @override
  List<Object> get props => [index, fieldName];

  @override
  String toString() =>
      'HandleToggleButtonClick(index: $index, fieldName : $fieldName)';
}

class HandleTextField extends RequestTutorFormEvent {
  const HandleTextField({this.value, this.fieldName});
  final String value;
  final String fieldName;

  @override
  List<Object> get props => [value, fieldName];

  @override
  String toString() => 'HandleTextField(value: $value, fieldName : $fieldName)';
}

class HandleRates extends RequestTutorFormEvent {
  const HandleRates({this.value, this.fieldName});
  final String value;
  final String fieldName;

  @override
  List<Object> get props => [value, fieldName];

  @override
  String toString() => 'HandleRates(value: $value, fieldName : $fieldName)';
}

class SubmitForm extends RequestTutorFormEvent {}

class ResetForm extends RequestTutorFormEvent {}
