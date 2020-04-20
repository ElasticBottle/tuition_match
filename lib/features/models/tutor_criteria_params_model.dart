import 'package:cotor/domain/entities/tutor_criteria_params.dart';
import 'package:cotor/features/models/criteria_params_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class TutorCriteriaParamsModel extends Equatable
    implements CriteriaParamsModel<TutorCriteriaParams>, TutorCriteriaParams {
  const TutorCriteriaParamsModel({
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

  factory TutorCriteriaParamsModel.fromDomainEntity(
      TutorCriteriaParams params) {
    return TutorCriteriaParamsModel(
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
  TutorCriteriaParams toDomainEntity() {
    return TutorCriteriaParamsModel(
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
