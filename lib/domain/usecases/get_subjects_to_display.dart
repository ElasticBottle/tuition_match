import 'package:cotor/domain/entities/level.dart';
import 'package:cotor/domain/entities/subject.dart';

class GetSubjectsToDisplay {
  GetSubjectsToDisplay();
  final Subject subjects = Subject();

  List<String> call(String level) {
    if (Level.pri.contains(level)) {
      return subjects.pri;
    } else if (Level.sec.contains(level)) {
      return subjects.sec;
    } else if (Level.jc.contains(level)) {
      return subjects.jc;
    } else if (Level.ib.contains(level)) {
      return subjects.ib;
    } else if (Level.uni.contains(level)) {
      return subjects.uni;
    } else if (Level.poly.contains(level)) {
      return subjects.poly;
    } else if (level == Level.OTHER) {
      return subjects.other;
    } else {
      return ['wrong level chosen'];
    }
  }
}
