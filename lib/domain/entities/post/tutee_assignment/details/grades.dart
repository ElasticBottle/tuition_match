import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  const Grade._(this._grades);
  final String _grades;

  static const Grade BAND1 = Grade._('Band 1');
  static const Grade BAND2 = Grade._('Band 2');
  static const Grade BAND3 = Grade._('Band 3');
  static const Grade BAND4 = Grade._('Band 4');
  static const Grade A1 = Grade._('A1');
  static const Grade A2 = Grade._('A2');
  static const Grade B3 = Grade._('B3');
  static const Grade B4 = Grade._('B4');
  static const Grade C5 = Grade._('C5');
  static const Grade C6 = Grade._('C6');
  static const Grade D7 = Grade._('D7');
  static const Grade E8 = Grade._('E8');
  static const Grade F9 = Grade._('F9');
  static const Grade GRADE1 = Grade._('Grade 1');
  static const Grade GRADE2 = Grade._('Grade 2');
  static const Grade GRADE3 = Grade._('Grade 3');
  static const Grade GRADE4 = Grade._('Grade 4');
  static const Grade GRADE5 = Grade._('Grade 5');
  static const Grade GRADE6 = Grade._('Grade 6');
  static const Grade GRADE7 = Grade._('Grade 7');
  static const Grade A = Grade._('A');
  static const Grade B = Grade._('B');
  static const Grade C = Grade._('C');
  static const Grade S = Grade._('S');
  static const Grade U = Grade._('U');
  static const Grade PASS = Grade._('Pass');
  static const Grade MERIT = Grade._('Merit');
  static const Grade DISTINCTION = Grade._('Distinction');

  @override
  List<Object> get props => [_grades];

  @override
  String toString() => _grades;
}
