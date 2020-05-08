import 'package:cotor/domain/entities/post/tutee_assignment/details/grade.dart';
import 'package:equatable/equatable.dart';

class GradeRecords extends Equatable {
  const GradeRecords({
    Grade start,
    Grade end,
  })  : _start = start,
        _end = end;

  final Grade _start;
  final Grade _end;
  Grade get end => _end;

  Grade get start => _start;

  @override
  List<Object> get props => [
        start,
        end,
      ];

  @override
  String toString() => '''GradeRecords( start: $start, end: $end, )''';
}
