import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'map_key_strings.dart';

class CriteriaParams extends Params {
  const CriteriaParams({
    this.level = Level.all,
    this.subject = const Subject(
      level: Level.all,
      subjectArea: SubjectArea.ANY,
    ),
    this.rateMin = 0,
    this.rateMax = 999,
  });

  factory CriteriaParams.fromMap(Map<String, dynamic> map) {
    return CriteriaParams(
      level: Level.values[int.parse(map[LEVEL])],
      subject: Subject(
          level: Level.values[int.parse(map[LEVEL])],
          subjectArea: map[SUBJECTAREA]),
      rateMin: double.parse(map[RATEMIN]),
      rateMax: double.parse(map[RATEMAX]),
    );
  }
  final Level level;
  final Subject subject;
  final double rateMin;
  final double rateMax;

  @override
  List<Object> get props => [
        level,
        subject,
        rateMin,
        rateMax,
      ];
}
