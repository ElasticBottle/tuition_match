import 'package:equatable/equatable.dart';

class RateTypes extends Equatable {
  const RateTypes._(this._type);
  final String _type;
  static const RateTypes HOURLY = RateTypes._('Hourly');
  static const RateTypes WEEKLY = RateTypes._('Weekly');
  static const RateTypes MONTHLY = RateTypes._('Monthly');

  static List<RateTypes> get types => const [
        HOURLY,
        WEEKLY,
        MONTHLY,
      ];

  static int toIndex(String rateType) {
    return types.indexOf(RateTypes._(rateType));
  }

  static RateTypes fromIndex(int rateTypeSelction) {
    return types[rateTypeSelction];
  }

  @override
  List<Object> get props => [_type];
}
