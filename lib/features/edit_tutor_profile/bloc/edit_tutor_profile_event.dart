part of 'edit_tutor_profile_bloc.dart';

abstract class EditTutorProfileEvent extends Equatable {
  const EditTutorProfileEvent();

  @override
  List<Object> get props => [];
}

class EditTutorProfileBlocInitialise extends EditTutorProfileEvent {
  const EditTutorProfileBlocInitialise({
    this.tutorProfile,
    this.userDetails,
    this.isCacheProfile = false,
  });
  final TutorProfile tutorProfile;
  final User userDetails;
  final bool isCacheProfile;

  @override
  List<Object> get props => [tutorProfile, userDetails, isCacheProfile];

  @override
  String toString() =>
      'InitialiseProfileFields(tutorProfile: $tutorProfile, userDetails: $userDetails, isCacheProfile: $isCacheProfile)';
}

/// [HandleToggleButtonClick] updates state fields with the latest toggled value(s)
/// Checks if the field is valid.
/// Results in an error state to be yielded if the field is empty
/// Fields are saved if valid. Removed if not
/// To be used by nonTextFields.
class HandleToggleButtonClick extends EditTutorProfileEvent {
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

class SubmitForm extends EditTutorProfileEvent {}

class CacheForm extends EditTutorProfileEvent {}

class ResetForm extends EditTutorProfileEvent {}
