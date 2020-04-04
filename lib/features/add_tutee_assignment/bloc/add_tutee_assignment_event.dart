part of 'add_tutee_assignment_bloc.dart';

abstract class AddTuteeAssignmentEvent extends Equatable {
  const AddTuteeAssignmentEvent();
}

class LevelChanged extends AddTuteeAssignmentEvent {
  const LevelChanged({this.level, this.currentIndex});
  final Level level;
  final int currentIndex;
  @override
  List<Object> get props => [level, currentIndex];

  @override
  String toString() =>
      'LevelChanged { level: $level, currentIndex: $currentIndex }';
}

class SpecificLevelChanged extends AddTuteeAssignmentEvent {
  const SpecificLevelChanged({this.specificLevel, this.specificLevelIndex});
  final Level specificLevel;
  final int specificLevelIndex;
  @override
  List<Object> get props => [specificLevel, specificLevelIndex];

  @override
  String toString() =>
      'SpecificLevelChanged { specificLevel: $specificLevel, specificLevelIndex: $specificLevelIndex }';
}

class SubjectClicked extends AddTuteeAssignmentEvent {
  const SubjectClicked({this.value, this.index});
  final dynamic value;
  final int index;
  @override
  List<Object> get props => [value, index];

  @override
  String toString() => 'SubjectChanged { option: $value, index: $index }';
}

class EventClicked extends AddTuteeAssignmentEvent {
  const EventClicked({
    this.value,
  });
  final List<dynamic> value;
  @override
  List<Object> get props => [value];

  @override
  String toString() => 'EventChanged { option: $value }';
}

class FormSaved extends AddTuteeAssignmentEvent {
  const FormSaved({
    this.value,
    this.key,
  });
  final String value;
  final String key;

  @override
  List<Object> get props => [value, key];

  @override
  String toString() => 'FormSaved { key : $key, value : $value }';
}

class FormSubmit extends AddTuteeAssignmentEvent {
  const FormSubmit();
  @override
  List<Object> get props => [];

  @override
  String toString() => 'FormSubmit { }';
}
