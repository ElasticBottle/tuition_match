import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/core/requirements_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/class_format.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/location.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/price.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/timing.dart';

class RequirementsTutor extends Equatable implements RequirementsBase {
  const RequirementsTutor({
    List<ClassFormat> classFormat,
    Price price,
    Timing timing,
    Location loc,
  })  : _classFormat = classFormat,
        _timing = timing,
        _loc = loc,
        _price = price;

  final List<ClassFormat> _classFormat;
  final Timing _timing;
  final Location _loc;
  final Price _price;

  @override
  List<ClassFormat> get classFormat => _classFormat;

  @override
  Location get location => _loc;

  @override
  Price get price => _price;

  @override
  Timing get timing => _timing;

  @override
  List<Object> get props => [
        _classFormat,
        _loc,
        _price,
        _timing,
      ];

  @override
  String toString() {
    return '''RequirementsTutor(
      classFormat: $classFormat, 
      timing: $timing, 
      loc: $location, 
      price: $price
    )''';
  }
}
