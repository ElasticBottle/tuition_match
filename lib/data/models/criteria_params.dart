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
    this.genders,
    this.tutorOccupations,
  }) : super(
          level: level,
          subject: subject,
          rateMin: rateMin,
          rateMax: rateMax,
        );

  factory TutorCriteriaParams.fromMap(Map<String, dynamic> map) {
    return TutorCriteriaParams(
      level: map[LEVEL],
      subject: SubjectModel.fromJson(map[SUBJECT]),
      rateMax: double.parse(map[RATEMAX]),
      rateMin: double.parse(map[RATEMIN]),
      genders: map[GENDER].map((int e) => Gender.values[e]).toList(),
      tutorOccupations: map[TUTOR_OCCUPATION]
          .map((int e) => TutorOccupation.values[e])
          .toList(),
    );
  }

  final List<Gender> genders;
  final List<TutorOccupation> tutorOccupations;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      LEVEL: level.index,
      SUBJECT: subject.toJson(),
      RATEMIN: rateMin,
      RATEMAX: rateMax,
      GENDERS: genders.map((e) => e.index).toList(),
      TUTOR_OCCUPATIONS: tutorOccupations.map((e) => e.index).toList(),
    };
  }

  @override
  List<Object> get props => [
        level,
        subject,
        rateMin,
        rateMax,
        genders,
        tutorOccupations,
      ];
}
