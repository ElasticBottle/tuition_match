import 'package:equatable/equatable.dart';

class RateTypes extends Equatable {
  const RateTypes(String type) : _type = type;

  final String _type;

  String get type => _type;

  @override
  String toString() => _type;

  @override
  List<Object> get props => [_type];

  static const RateTypes HOURLY = RateTypes('Hourly');
  static const RateTypes WEEKLY = RateTypes('Weekly');
  static const RateTypes MONTHLY = RateTypes('Monthly');

  static List<RateTypes> get types => const [
        HOURLY,
        WEEKLY,
        MONTHLY,
      ];

  static int toIndex(String rateType) {
    return types.indexOf(RateTypes(rateType));
  }

  static RateTypes fromIndex(int rateTypeSelction) {
    return types[rateTypeSelction];
  }
}
