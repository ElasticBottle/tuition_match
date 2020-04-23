part of 'edit_tutor_profile_bloc.dart';

abstract class EditTutorProfileEvent extends Equatable {
  const EditTutorProfileEvent();

  @override
  List<Object> get props => [];
}

class InitialiseProfileFields extends EditTutorProfileEvent {
  const InitialiseProfileFields({
    this.tutorProfile,
    this.userDetails,
    this.isCacheProfile = false,
  });
  final TutorProfileModel tutorProfile;
  final UserModel userDetails;
  final bool isCacheProfile;

  @override
  List<Object> get props => [tutorProfile, userDetails, isCacheProfile];

  @override
  String toString() =>
      'InitialiseProfileFields(tutorProfile: $tutorProfile, userDetails: $userDetails, isCacheProfile: $isCacheProfile)';
}

// class CheckRatesAreValid extends EditTutorProfileEvent {
//   const CheckRatesAreValid({
//     @required this.fieldName,
//     @required this.toCheck,
//   });
//   final String toCheck;
//   final String fieldName;

//   @override
//   List<Object> get props => [toCheck, fieldName];

//   @override
//   String toString() =>
//       'CheckRatesAreValid(toCheck: $toCheck, fieldName: $fieldName)';
// }

// class CheckTextFieldNotEmpty extends EditTutorProfileEvent {
//   const CheckTextFieldNotEmpty({
//     @required this.fieldName,
//     @required this.toCheck,
//   });
//   final String toCheck;
//   final String fieldName;
//   @override
//   List<Object> get props => [toCheck, fieldName];

//   @override
//   String toString() =>
//       'CheckTextFieldNotEmpty(toCheck: $toCheck, fieldName: $fieldName)';
// }

// class CheckDropDownNotEmpty extends EditTutorProfileEvent {
//   const CheckDropDownNotEmpty({@required this.fieldName});
//   final String fieldName;

//   @override
//   List<Object> get props => [fieldName];

//   @override
//   String toString() => 'CheckDropDownNotEmpty(fieldName: $fieldName)';
// }

/// [HandleToggleButtonClick] should be called before [CheckDropDownNotEmpty] or [SaveField].
/// Updates state fields with the latest toggled value(s)
/// To be used by nonTextFields.
class HandleToggleButtonClick extends EditTutorProfileEvent {
  const HandleToggleButtonClick({this.index, this.fieldName});
  final dynamic index;
  final String fieldName;

  @override
  List<Object> get props => [index, fieldName];

  @override
  String toString() =>
      'HandleToggleButtonClick(index: $index, fieldName : $fieldName)';
}

class HandleTextField extends EditTutorProfileEvent {
  const HandleTextField({this.value, this.fieldName});
  final String value;
  final String fieldName;

  @override
  List<Object> get props => [value, fieldName];

  @override
  String toString() => 'HandleTextField(value: $value, fieldName : $fieldName)';
}

class HandleRates extends EditTutorProfileEvent {
  const HandleRates({this.value, this.fieldName});
  final String value;
  final String fieldName;

  @override
  List<Object> get props => [value, fieldName];

  @override
  String toString() => 'HandleRates(value: $value, fieldName : $fieldName)';
}
// class SaveField extends EditTutorProfileEvent {
//   const SaveField({this.key, this.value});
//   final String key;
//   final dynamic value;

//   @override
//   List<Object> get props => [key, value];

//   @override
//   String toString() => 'SaveField(key: $key, value: $value)';
// }

class SubmitForm extends EditTutorProfileEvent {}

class CacheForm extends EditTutorProfileEvent {}

class ResetForm extends EditTutorProfileEvent {}
