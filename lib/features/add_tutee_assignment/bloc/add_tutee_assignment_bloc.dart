import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'package:equatable/equatable.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:flutter/foundation.dart';

part 'add_tutee_assignment_event.dart';
part 'add_tutee_assignment_state.dart';

class AddTuteeAssignmentBloc
    extends Bloc<AddTuteeAssignmentEvent, AddTuteeFormState> {
  AddTuteeAssignmentBloc();

  Map<String, List<dynamic>> values = <String, List<dynamic>>{};
  Map<String, String> stringValues = <String, String>{};

  List<String> initialLevels;
  List<Level> initialLevelsValue;
  List<String> specificLevels;
  List<Level> specificLevelsValue;
  List<String> subjects;

  @override
  AddTuteeFormState get initialState {
    const Level currentLevel = Level.pri;
    const Level currentSpecificLevel = Level.pri1;

    return AddTuteeFormState(
      currentLevel: currentLevel,
      currentLevelIndex: 0,
      currentSpecificLevel: currentSpecificLevel,
      currentSpecificLevelIndex: 0,
      currentSubject: Languages.ENG,
      currentSubjectIndex: 0,
      initialLevels: Helper.initialiseLevels(),
      initialLevelsValue: Helper.initialiseLevelValues(),
      specificLevels: Helper.getSpecificLevels(currentLevel),
      specificLevelsValue: Helper.getSpecificLevelValues(currentLevel),
      subjects: Helper.getAppropriateSubjectList(currentSpecificLevel),
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  @override
  Stream<AddTuteeFormState> mapEventToState(
    AddTuteeAssignmentEvent event,
  ) async* {
    if (event is LevelChanged) {
      yield* _mapLevelChangedToState(event.level, event.currentIndex);
    } else if (event is SpecificLevelChanged) {
      yield* _mapSpecificLevelChangedToState(
          event.specificLevel, event.specificLevelIndex);
    } else if (event is SubjectClicked) {
      yield* _mapSubjectClickedToState(event.value);
    } else if (event is EventClicked) {
      yield* _mapEventClickedToState(event.value);
    } else if (event is FormSaved) {
      yield* _mapFormSavedToState(event.key, event.value);
    } else if (event is FormSubmit) {
      yield* _mapFormSubmitToState();
    }
  }

  Stream<AddTuteeFormState> _mapLevelChangedToState(
      Level level, int index) async* {
    yield state.copyWith(
        currentLevel: level,
        currentLevelIndex: index,
        specificLevels: Helper.getSpecificLevels(level),
        specificLevelsValue: Helper.getSpecificLevelValues(level));
  }

  Stream<AddTuteeFormState> _mapSpecificLevelChangedToState(
      Level specificLevel, int specificLevelIndex) async* {
    values.addAll(<String, List<Level>>{
      LEVEL: [specificLevel]
    });
    yield state.copyWith(
      currentSpecificLevel: specificLevel,
      currentSpecificLevelIndex: specificLevelIndex,
      subjects: Helper.getAppropriateSubjectList(specificLevel),
    );
  }

  Stream<AddTuteeFormState> _mapSubjectClickedToState(dynamic value) async* {
    values.addAll(<String, List<Subject>>{
      SUBJECT: [Subject(level: state.currentSpecificLevel, subjectArea: value)]
    });
    yield state;
  }

  Stream<AddTuteeFormState> _mapEventClickedToState(
      List<dynamic> value) async* {
    if (value.isNotEmpty) {
      if (value.first is Gender) {
        print('adding gender');
        values.addAll(<String, List<dynamic>>{GENDER: value});
      } else if (value.first is TutorOccupation) {
        values.addAll(<String, List<dynamic>>{TUTOR_OCCUPATION: value});
      } else if (value.first is ClassFormat) {
        values.addAll(<String, List<dynamic>>{CLASSFORMAT: value});
      }
    }
    print('values so far for the map ' + values.toString());
    yield state;
  }

  Stream<AddTuteeFormState> _mapFormSavedToState(
      String key, String value) async* {
    stringValues.addAll({key: value});
    print(stringValues);
    yield state;
  }

  Stream<AddTuteeFormState> _mapFormSubmitToState() async* {
    yield state.copyWith(isSubmitting: true);
    // TODO(ElasticBottle): Figure out how to mash everything together in terms of state.
  }
}

class FormError {
  String gender;
  String tutorOccupation;
  String classFormat;
  String location;
  String timing;
  String freq;
  String rateMin;
  String rateMax;
  String additionalRemarks;

  @override
  String toString() => 'Errors: { gender: $gender '
      'tutorOccupation: $tutorOccupation'
      'classFormat: $classFormat'
      'locatio: $location'
      'timing: $timing'
      'freq: $freq'
      'rateMin: $rateMin'
      'rateMax: $rateMax'
      'additional Remarks: $additionalRemarks';
}

class Helper {
  static List<String> getAppropriateSubjectList(Level level) {
    final List<String> results = [];
    switch (level) {
      case Level.K1:
      case Level.K2:
        results.addAll([
          Languages.ENG,
          Languages.CHI,
          Languages.MALAY,
          Languages.HINDI,
          Languages.TAMIL,
          Math.MATH,
        ]);
        break;
      case Level.pri1:
      case Level.pri2:
      case Level.pri3:
        results.addAll([
          Languages.ENG,
          Languages.CHI,
          Languages.MALAY,
          Languages.HINDI,
          Languages.TAMIL,
          Math.MATH,
        ]);
        break;
      case Level.pri4:
      case Level.pri5:
      case Level.pri6:
        results.addAll([
          Languages.ENG,
          Languages.CHI,
          Languages.MALAY,
          Languages.HINDI,
          Languages.TAMIL,
          Math.MATH,
          Science.SCIENCE,
        ]);
        break;
      case Level.sec1:
      case Level.sec2:
        results.addAll([
          Languages.ENG,
          Languages.CHI,
          Languages.MALAY,
          Languages.HINDI,
          Languages.TAMIL,
          Math.MATH,
          Science.SCIENCE,
          Science.BIO,
          Science.CHEM,
          Science.PHY
        ]);
        break;
      case Level.sec3:
      case Level.sec4:
        results.addAll([
          Languages.ENG,
          Languages.CHI,
          Languages.MALAY,
          Languages.HINDI,
          Languages.TAMIL,
          Math.MATH,
          Math.AMATH,
          Science.BIO,
          Science.CHEM,
          Science.PHY,
          Humans.ART,
          Humans.GEOG,
          Humans.HIST,
          Humans.LIT,
          Humans.POA,
          Humans.SS,
          Music.PIANO,
        ]);
        break;
      case Level.jC1:
      case Level.jC2:
        // TODO(ElasticBottle): Handle this case.
        break;
      case Level.poly:
        // TODO(ElasticBottle): Handle this case.
        break;
      case Level.uni:
        // TODO(ElasticBottle): Handle this case.
        break;
      case Level.other:
        // TODO(ElasticBottle): Handle this case.
        break;
      default:
        break;
    }
    print(results);
    return results;
  }

  static List<String> initialiseLevels() {
    final List<String> temp = [];
    temp.add(describeEnum(Level.pri));
    temp.add(describeEnum(Level.sec));
    temp.add(describeEnum(Level.jc));
    temp.add(describeEnum(Level.poly));
    temp.add(describeEnum(Level.uni));
    temp.add(describeEnum(Level.other));
    return temp;
  }

  static List<Level> initialiseLevelValues() {
    final List<Level> temp = [];
    temp.add(Level.pri);
    temp.add(Level.sec);
    temp.add(Level.jc);
    temp.add(Level.poly);
    temp.add(Level.uni);
    temp.add(Level.other);
    return temp;
  }

  static List<String> getSpecificLevels(Level currentLevel) {
    final List<String> temp = [];
    switch (currentLevel) {
      case Level.preSchool:
        temp.add(describeEnum(Level.K1));
        temp.add(describeEnum(Level.K2));
        break;
      case Level.pri:
        temp.add(describeEnum(Level.pri1));
        temp.add(describeEnum(Level.pri2));
        temp.add(describeEnum(Level.pri3));
        temp.add(describeEnum(Level.pri4));
        temp.add(describeEnum(Level.pri5));
        temp.add(describeEnum(Level.pri6));
        break;
      case Level.sec:
        temp.add(describeEnum(Level.sec1));
        temp.add(describeEnum(Level.sec2));
        temp.add(describeEnum(Level.sec3));
        temp.add(describeEnum(Level.sec4));
        break;
      case Level.jc:
        temp.add(describeEnum(Level.jC1));
        temp.add(describeEnum(Level.jC2));
        break;
      case Level.poly:
        temp.add(describeEnum(Level.poly1));
        temp.add(describeEnum(Level.poly2));
        temp.add(describeEnum(Level.poly3));
        break;
      default:
        break;
    }
    print(temp);
    return temp;
  }

  static List<Level> getSpecificLevelValues(Level currentLevel) {
    final List<Level> temp = [];
    switch (currentLevel) {
      case Level.preSchool:
        temp.add(Level.K1);
        temp.add(Level.K2);
        break;
      case Level.pri:
        temp.add(Level.pri1);
        temp.add(Level.pri2);
        temp.add(Level.pri3);
        temp.add(Level.pri4);
        temp.add(Level.pri5);
        temp.add(Level.pri6);
        break;
      case Level.sec:
        temp.add(Level.sec1);
        temp.add(Level.sec2);
        temp.add(Level.sec3);
        temp.add(Level.sec4);
        break;
      case Level.jc:
        temp.add(Level.jC1);
        temp.add(Level.jC2);
        break;
      case Level.poly:
        temp.add(Level.poly1);
        temp.add(Level.poly2);
        temp.add(Level.poly3);
        break;
      default:
        break;
    }
    return temp;
  }
}
