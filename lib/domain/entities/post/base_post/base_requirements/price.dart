import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:cotor/domain/entities/post/base_post/base_requirements/rate_types.dart';

class Price extends Equatable {
  const Price({
    double maxRate,
    double minRate,
    double proposedRate,
    @required RateTypes rateType,
  })  : _maxRate = maxRate ?? 0.0,
        _minRate = minRate ?? 0.0,
        _proposedRate = proposedRate ?? 0.0,
        _rateType = rateType;

  final double _maxRate;
  final double _minRate;
  final double _proposedRate;
  final RateTypes _rateType;
  double get maxRate => _maxRate;

  double get minRate => _minRate;

  double get proposedRate => _proposedRate;

  RateTypes get rateType => _rateType;

  @override
  String toString() {
    return 'Price(maxRate: $maxRate, minRate: $minRate, proposedRate: $proposedRate, rateType: $rateType)';
  }

  @override
  List<Object> get props => [
        minRate,
        maxRate,
        proposedRate,
        rateType,
      ];
}
