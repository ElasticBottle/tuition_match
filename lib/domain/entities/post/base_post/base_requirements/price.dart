import 'package:cotor/domain/entities/post/base_post/base_requirements/rate_types.dart';
import 'package:equatable/equatable.dart';

class Price extends Equatable {
  const Price({
    double maxRate,
    double minRate,
    double proposedRate,
    RateTypes rateType,
  })  : _maxRate = maxRate,
        _minRate = minRate,
        _proposedRate = proposedRate,
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
    return 'PriceEntity(_maxRate: $_maxRate, _minRate: $_minRate, _proposedRate: $_proposedRate, _rateType: $_rateType)';
  }

  @override
  List<Object> get props => [
        minRate,
        maxRate,
        proposedRate,
        rateType,
      ];
}
