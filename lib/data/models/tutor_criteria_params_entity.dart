import 'package:cotor/data/models/criteria_params_entity.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/tutor_criteria_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class TutorCriteriaParamsEntity extends Equatable
    implements CriteriaParamsEntity<TutorCriteriaParams>, TutorCriteriaParams {
  const TutorCriteriaParamsEntity({
    @required List<String> genders,
    @required List<String> tutorOccupations,
    @required List<String> levelsTaught,
    @required List<String> subjects,
    @required List<String> formats,
    @required double rateMin,
    @required double rateMax,
  })  : _genders = genders,
        _tutorOccupations = tutorOccupations,
        _levelsTaught = levelsTaught,
        _subjects = subjects,
        _formats = formats,
        _rateMin = rateMin,
        _rateMax = rateMax;

  factory TutorCriteriaParamsEntity.fromMap(Map<String, dynamic> map) {
    return TutorCriteriaParamsEntity(
      levelsTaught: map[LEVELS_TAUGHT],
      subjects: map[SUBJECTS],
      genders: map[GENDER],
      tutorOccupations: map[TUTOR_OCCUPATION],
      formats: map[CLASS_FORMATS],
      rateMin: double.parse(map[RATEMIN]),
      rateMax: double.parse(map[RATEMAX]),
    );
  }
  factory TutorCriteriaParamsEntity.fromDomainEntity(
      TutorCriteriaParams params) {
    return TutorCriteriaParamsEntity(
      levelsTaught: params.levelsTaught,
      formats: params.formats,
      genders: params.genders,
      subjects: params.subjects,
      tutorOccupations: params.tutorOccupations,
      rateMax: params.rateMax,
      rateMin: params.rateMin,
    );
  }

  final List<String> _genders;
  final List<String> _tutorOccupations;
  final List<String> _levelsTaught;
  final List<String> _subjects;
  final List<String> _formats;
  final double _rateMin;
  final double _rateMax;

  @override
  List<String> get genders => _genders;
  @override
  List<String> get tutorOccupations => _tutorOccupations;
  @override
  List<String> get levelsTaught => _levelsTaught;
  @override
  List<String> get subjects => _subjects;
  @override
  List<String> get formats => _formats;
  @override
  double get rateMin => _rateMin;
  @override
  double get rateMax => _rateMax;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      RATEMIN: rateMin,
      RATEMAX: rateMax,
      LEVELS_TAUGHT: levelsTaught,
      SUBJECTS: subjects,
      TUTOR_GENDER: genders,
      TUTOR_OCCUPATIONS: tutorOccupations,
      CLASS_FORMATS: formats,
    };
  }

  @override
  TutorCriteriaParams toDomainParams() {
    return TutorCriteriaParamsEntity(
      genders: genders,
      tutorOccupations: tutorOccupations,
      formats: formats,
      subjects: subjects,
      levelsTaught: levelsTaught,
      rateMax: rateMax,
      rateMin: rateMin,
    );
  }

  @override
  List<Object> get props => [
        levelsTaught,
        subjects,
        formats,
        genders,
        tutorOccupations,
        rateMin,
        rateMax,
      ];
}
