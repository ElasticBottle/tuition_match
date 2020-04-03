import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';

part 'add_tutee_assignment_event.dart';
part 'add_tutee_assignment_state.dart';

class AddTuteeAssignmentBloc
    extends Bloc<AddTuteeAssignmentEvent, AddTuteeAssignmentState> {
  AddTuteeAssignmentBloc();
  @override
  AddTuteeAssignmentState get initialState {
    final List<String> levels = Helper.initialiseLevels();
    return AddTuteeAssignmentInitial(level: levels);
  }

  @override
  Stream<AddTuteeAssignmentState> mapEventToState(
    AddTuteeAssignmentEvent event,
  ) async* {
    if (event is LevelChanged) {
      print('event is level changed');
      yield* _mapLevelChangedToState(event.level);
    }
  }

  Stream<AddTuteeAssignmentState> _mapLevelChangedToState(String level) async* {
    final List<String> subjects = Helper.getAppropriateSubjectList(level);
    yield SubjectLoaded(subjects: subjects);
  }
}

class Helper {
  static List<String> getAppropriateSubjectList(String level) {
    List<String> results;
    switch (stringToEnum(level)) {
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
          Humans.SS
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
    final List<String> temp = Level.values.map((e) => describeEnum(e)).toList();
    temp.remove('pri');
    temp.remove('sec');
    temp.remove('jc');
    temp.remove('all');
    return temp;
  }
}
