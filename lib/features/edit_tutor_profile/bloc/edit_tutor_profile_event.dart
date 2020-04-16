part of 'edit_tutor_profile_bloc.dart';

abstract class EditTutorProfileEvent extends Equatable {
  const EditTutorProfileEvent();

  @override
  List<Object> get props => [];
}

class CheckRatesAreValid extends EditTutorProfileEvent {
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

class CheckTextFieldNotEmpty extends EditTutorProfileEvent {
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

class CheckDropDownNotEmpty extends EditTutorProfileEvent {
  const CheckDropDownNotEmpty({@required this.fieldName});
  final String fieldName;

  @override
  List<Object> get props => [fieldName];

  @override
  String toString() => 'CheckDropDownNotEmpty(fieldName: $fieldName)';
}

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

class SaveField extends EditTutorProfileEvent {
  const SaveField({this.key, this.value});
  final String key;
  final dynamic value;

  @override
  List<Object> get props => [key, value];

  @override
  String toString() => 'SaveField(key: $key, value: $value)';
}

class SubmitForm extends EditTutorProfileEvent {}

class InitialiseFields extends EditTutorProfileEvent {
  const InitialiseFields({
    this.name,
    this.photoUrl,
    this.isVerifiedTutor,
    this.isTutor,
    this.tutorProfile,
    this.userId,
  });
  final TutorProfile tutorProfile;
  final String userId;
  final Name name;
  final String photoUrl;
  final bool isVerifiedTutor;
  final bool isTutor;

  @override
  List<Object> get props =>
      [tutorProfile, userId, name, photoUrl, isVerifiedTutor, isTutor];

  @override
  String toString() {
    return 'InitialiseFields(tutorProfile: $tutorProfile, userId: $userId, name: $name, photoUrl: $photoUrl, isVerifiedTutor: $isVerifiedTutor, isTutor: $isTutor)';
  }
}
