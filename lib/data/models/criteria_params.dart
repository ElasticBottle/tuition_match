import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/data/models/subject_model.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'map_key_strings.dart';

class CriteriaParams extends Params {
  const CriteriaParams({
    this.level = Level.all,
    this.subject = const SubjectModel(
      level: Level.all,
      sbjArea: SubjectArea.ANY,
    ),
    this.rateMin = 0,
    this.rateMax = 999,
  });

  factory CriteriaParams.fromMap(Map<String, dynamic> map) {
    return CriteriaParams(
      level: Level.values[int.parse(map[LEVEL])],
      subject: SubjectModel.fromJson(map[SUBJECT]),
      rateMin: double.parse(map[RATEMIN]),
      rateMax: double.parse(map[RATEMAX]),
    );
  }
  final Level level;
  final SubjectModel subject;
  final double rateMin;
  final double rateMax;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      LEVEL: level.index,
      SUBJECT: subject.toJson(),
      RATEMIN: rateMin,
      RATEMAX: rateMax,
    };
  }

  @override
  List<Object> get props => [
        level,
        subject,
        rateMin,
        rateMax,
      ];
}

class TutorCriteriaParams extends CriteriaParams {
  const TutorCriteriaParams({
    Level level = Level.all,
    SubjectModel subject = const SubjectModel(
      level: Level.all,
      sbjArea: SubjectArea.ANY,
    ),
    double rateMin = 0,
    double rateMax = 999,
    this.gender,
    this.tutorOccupation,
  }) : super(
          level: level,
          subject: subject,
          rateMin: rateMin,
          rateMax: rateMax,
        );

  final Gender gender;
  final TutorOccupation tutorOccupation;
}
