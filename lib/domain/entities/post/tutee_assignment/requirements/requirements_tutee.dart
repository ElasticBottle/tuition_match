import 'package:cotor/domain/entities/core/requirements_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/class_format.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/location.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/price.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/timing.dart';
import 'package:cotor/domain/entities/post/base_post/gender.dart';
import 'package:cotor/domain/entities/post/base_post/tutor_occupation.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/frequency.dart';
import 'package:equatable/equatable.dart';

class RequirementsTutee extends Equatable implements RequirementsBase {
  const RequirementsTutee({
    List<ClassFormat> classFormat,
    Frequency freq,
    Timing timing,
    Location location,
    Price price,
    List<Gender> tutorGenders,
    List<TutorOccupation> tutorOccupations,
  })  : _classFormat = classFormat,
        _freq = freq,
        _timing = timing,
        _loc = location,
        _price = price,
        _tutorGenders = tutorGenders,
        _tutorOccupations = tutorOccupations;

  final List<ClassFormat> _classFormat;
  final Frequency _freq;
  final Timing _timing;
  final Location _loc;
  final Price _price;
  final List<Gender> _tutorGenders;
  final List<TutorOccupation> _tutorOccupations;

  @override
  List<ClassFormat> get classFormat => _classFormat;

  Frequency get freq => _freq;

  @override
  Location get location => _loc;

  @override
  Price get price => _price;

  @override
  Timing get timing => _timing;

  List<Gender> get tutorGender => _tutorGenders;

  List<TutorOccupation> get tutorOccupation => _tutorOccupations;

  @override
  List<Object> get props => [
        _classFormat,
        _freq,
        _loc,
        _price,
        _timing,
        _tutorGenders,
        _tutorOccupations,
      ];

  @override
  String toString() => '''RequirementsTutee(
      classFormat: $classFormat,
      freq: $freq,
      timing: $timing,
      loc: $location,
      price: $price,
      tutorGenders: $tutorGender,
      tutorOccupations: $tutorOccupation,
    }''';
}
