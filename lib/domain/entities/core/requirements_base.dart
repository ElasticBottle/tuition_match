import 'package:cotor/domain/entities/post/base_post/base_requirements/class_format.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/location.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/price.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/timing.dart';

abstract class RequirementsBase {
  Location get location;
  Timing get timing;
  Price get price;
  List<ClassFormat> get classFormat;
}
