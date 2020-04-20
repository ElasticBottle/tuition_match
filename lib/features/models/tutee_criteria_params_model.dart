import 'package:cotor/domain/entities/tutee_criteria_params.dart';
import 'package:cotor/features/models/criteria_params_model.dart';
import 'package:equatable/equatable.dart';

class TuteeCriteriaParamsModel extends Equatable
    implements CriteriaParamsModel<TuteeCriteriaParams>, TuteeCriteriaParams {
  const TuteeCriteriaParamsModel({
    List<String> genders,
    List<String> tutorOccupations,
    List<String> levels,
    List<String> subjects,
    List<String> formats,
    double rateMin,
    double rateMax,
  })  : _genders = genders,
        _tutorOccupations = tutorOccupations,
        _levels = levels,
        _subjects = subjects,
        _formats = formats,
        _rateMin = rateMin,
        _rateMax = rateMax;

  factory TuteeCriteriaParamsModel.fromDomainEntity(
      TuteeCriteriaParams params) {
    return TuteeCriteriaParamsModel(
      levels: params.levels,
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
  final List<String> _levels;
  final List<String> _subjects;
  final List<String> _formats;
  final double _rateMin;
  final double _rateMax;

  @override
  List<String> get genders => _genders;
  @override
  List<String> get tutorOccupations => _tutorOccupations;
  @override
  List<String> get levels => _levels;
  @override
  List<String> get subjects => _subjects;
  @override
  List<String> get formats => _formats;
  @override
  double get rateMin => _rateMin;
  @override
  double get rateMax => _rateMax;

  @override
  TuteeCriteriaParams toDomainEntity() {
    return TuteeCriteriaParamsModel(
      genders: genders,
      tutorOccupations: tutorOccupations,
      formats: formats,
      subjects: subjects,
      levels: levels,
      rateMax: rateMax,
      rateMin: rateMin,
    );
  }

  @override
  List<Object> get props => [
        levels,
        subjects,
        formats,
        genders,
        tutorOccupations,
        rateMin,
        rateMax,
      ];
}
