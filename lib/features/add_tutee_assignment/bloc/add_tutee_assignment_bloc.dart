import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
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

  Map<String, List<dynamic>> values = <String, List<dynamic>>{
    LEVEL: <dynamic>[],
    SUBJECT: <dynamic>[],
    GENDER: <dynamic>[],
    TUTOR_OCCUPATION: <dynamic>[],
    CLASSFORMAT: <dynamic>[]
  };
  Map<String, String> stringValues = <String, String>{};

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
        values.addAll(<String, List<dynamic>>{GENDER: value});
      } else if (value.first is TutorOccupation) {
        values.addAll(<String, List<dynamic>>{TUTOR_OCCUPATION: value});
      } else if (value.first is ClassFormat) {
        values.addAll(<String, List<dynamic>>{CLASSFORMAT: value});
      }
    }
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
    final FormError error = FormError.validateFields(values, stringValues);
    await Future<dynamic>.delayed(Duration(seconds: 1));
    if (error.hasErrors) {
      yield state.copyWith(
        isSubmitting: false,
        isFailure: true,
        genderError: error.gender,
        formatError: error.classFormat,
        freqError: error.freq,
        locationError: error.location,
        rateMaxError: error.rateMax,
        rateMinError: error.rateMin,
        occupationError: error.tutorOccupation,
        timingError: error.timing,
      );
    } else {
      yield state.copyWith(isSuccess: true, isSubmitting: false);
    }
  }
}

class FormError {
  FormError({
    this.gender,
    this.tutorOccupation,
    this.classFormat,
    this.location,
    this.timing,
    this.freq,
    this.rateMin,
    this.rateMax,
    this.additionalRemarks,
    this.hasErrors,
  });
  final String gender;
  final String tutorOccupation;
  final String classFormat;
  final String location;
  final String timing;
  final String freq;
  final String rateMin;
  final String rateMax;
  final String additionalRemarks;
  bool hasErrors;

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

  static FormError validateFields(
      Map<String, List> values, Map<String, String> stringValues) {
    String gender;
    String tutorOccupation;
    String classFormat;
    String location;
    String timing;
    String freq;
    String rateMin;
    String rateMax;
    String additionalRemarks;
    bool hasErrors = false;

    for (MapEntry<String, List> entry in values.entries) {
      if (entry.value.isEmpty) {
        hasErrors = true;
        switch (entry.key) {
          case GENDER:
            gender = Strings.addTuteeCheckBoxError;
            break;
          case TUTOR_OCCUPATION:
            tutorOccupation = Strings.addTuteeCheckBoxError;
            break;
          case CLASSFORMAT:
            classFormat = Strings.addTuteeCheckBoxError;
            break;
        }
      }
    }

    for (MapEntry<String, String> entry in stringValues.entries) {
      if (entry.value.isEmpty) {
        if (entry.key != ADDITIONAL_REMARKS) {
          hasErrors = true;
        }
        switch (entry.key) {
          case LOCATION:
            location = Strings.addTuteeTextFieldError;
            break;
          case TIMING:
            timing = Strings.addTuteeTextFieldError;
            break;
          case FREQ:
            freq = Strings.addTuteeTextFieldError;
            break;
          case RATEMIN:
            rateMin = Strings.addTuteeTextFieldError;
            break;
          case RATEMAX:
            rateMax = Strings.addTuteeTextFieldError;
            break;
          case ADDITIONAL_REMARKS:
            break;
        }
      }
    }

    final FormError error = FormError(
      gender: gender,
      tutorOccupation: tutorOccupation,
      classFormat: classFormat,
      location: location,
      timing: timing,
      freq: freq,
      rateMin: rateMin,
      rateMax: rateMax,
      additionalRemarks: additionalRemarks,
      hasErrors: hasErrors,
    );
    return error;
  }
}

class Helper {
  static List<String> getAppropriateSubjectList(Level level) {
    final List<String> results = [];
    switch (level) {
      case Level.K1:
      case Level.K2:
        results.addAll([
          Music.PIANO,
          Music.VIOLIN,
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
          Music.PIANO,
          Music.VIOLIN
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
          Music.PIANO,
          Music.VIOLIN,
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
          Science.PHY,
          Music.PIANO,
          Music.VIOLIN,
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
          Music.VIOLIN,
        ]);
        break;
      case Level.jC1:
      case Level.jC2:
        results.addAll([
          Languages.ENG,
          Math.H1MATH,
          Math.H2MATH,
          Science.H1BIO,
          Science.H2BIO,
          Science.H1CHEM,
          Science.H2CHEM,
          Science.H1PHY,
          Science.H2PHY,
          Humans.ART,
          Humans.GEOG,
          Humans.HIST,
          Humans.LIT,
          Languages.CHI,
          Languages.MALAY,
          Languages.HINDI,
          Languages.TAMIL,
          Music.PIANO,
          Music.VIOLIN,
        ]);
        break;
      case Level.poly:
        // TODO(ElasticBottle): Handle this case.
        break;
      case Level.uni:
        // TODO(ElasticBottle): Handle this case.
        break;
      case Level.other:
        results.addAll([
          Music.PIANO,
          Music.VIOLIN,
          Music.GUITAR,
          Music.DRUMS,
        ]);
        break;
      default:
        break;
    }
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
