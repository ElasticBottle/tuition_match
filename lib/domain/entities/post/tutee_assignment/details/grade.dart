import 'package:equatable/equatable.dart';

const String band = 'Band';
const String gradeString = 'Grade';
const String pass = 'Pass';
const String merit = 'Merit';
const String distinction = 'Distinction';

class Grade extends Equatable {
  const Grade(String grade) : _grades = grade;

  final String _grades;

  String get grade => _grades;

  @override
  List<Object> get props => [_grades];

  @override
  String toString() => _grades;

  static const Grade BAND1 = Grade(band + ' 1');
  static const Grade BAND2 = Grade(band + ' 2');
  static const Grade BAND3 = Grade(band + ' 3');
  static const Grade BAND4 = Grade(band + ' 4');
  static const Grade A1 = Grade('A1');
  static const Grade A2 = Grade('A2');
  static const Grade B3 = Grade('B3');
  static const Grade B4 = Grade('B4');
  static const Grade C5 = Grade('C5');
  static const Grade C6 = Grade('C6');
  static const Grade D7 = Grade('D7');
  static const Grade E8 = Grade('E8');
  static const Grade F9 = Grade('F9');
  static const Grade GRADE1 = Grade(gradeString + ' 1');
  static const Grade GRADE2 = Grade(gradeString + ' 2');
  static const Grade GRADE3 = Grade(gradeString + ' 3');
  static const Grade GRADE4 = Grade(gradeString + ' 4');
  static const Grade GRADE5 = Grade(gradeString + ' 5');
  static const Grade GRADE6 = Grade(gradeString + ' 6');
  static const Grade GRADE7 = Grade(gradeString + ' 7');
  static const Grade A = Grade('A');
  static const Grade B = Grade('B');
  static const Grade C = Grade('C');
  static const Grade D = Grade('D');
  static const Grade S = Grade('S');
  static const Grade U = Grade('U');
  static const Grade PASS = Grade(pass);
  static const Grade MERIT = Grade(merit);
  static const Grade DISTINCTION = Grade(distinction);
}
