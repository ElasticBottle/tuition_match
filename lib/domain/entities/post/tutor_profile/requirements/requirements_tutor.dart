import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:cotor/domain/entities/core/requirements_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/class_format.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/location.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/price.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/timing.dart';

class RequirementsTutor extends Equatable implements RequirementsBase {
  const RequirementsTutor({
    @required List<ClassFormat> classFormat,
    @required Price price,
    @required Timing timing,
    @required Location location,
  })  : _classFormat = classFormat,
        _timing = timing,
        _loc = location,
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
