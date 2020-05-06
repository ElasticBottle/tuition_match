import 'package:cotor/domain/entities/post/base_post/base_requirements/rate_types.dart';

abstract class Price {
  double get maxRate;
  double get minRate;
  double get proposedRate;
  RateTypes get rateType;
}
