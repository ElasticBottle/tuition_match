part of 'add_tutee_assignment_bloc.dart';

abstract class AddTuteeAssignmentEvent extends Equatable {
  const AddTuteeAssignmentEvent();
}

class AddAssignment extends AddTuteeAssignmentEvent {
  const AddAssignment({
    this.gender,
    this.level,
    this.subjectModel,
    this.format,
    this.timing,
    this.rateMin,
    this.rateMax,
    this.location,
    this.freq,
    this.tutorOccupation,
    this.additionalRemarks,
    this.status,
    this.username,
    this.firstName,
    this.lastName,
    this.applied,
    this.liked,
  });
  final int gender;
  final int level;
  final int subjectModel;
  final int format;
  final String timing;
  final double rateMin;
  final double rateMax;
  final String location;
  final String freq;
  final int tutorOccupation;
  final String additionalRemarks;
  final int status;
  final String username;
  final String firstName;
  final String lastName;
  final int applied;
  final int liked;
  @override
  List<Object> get props => [];

  @override
  String toString() => 'AddAssignment {}';
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

class SubjectClicked extends AddTuteeAssignmentEvent {
  const SubjectClicked({this.value, this.index});
  final dynamic value;
  final int index;
  @override
  List<Object> get props => [value, index];

  @override
  String toString() => 'SubjectChanged { option: $value, index: $index }';
}
