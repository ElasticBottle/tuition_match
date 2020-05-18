import 'package:equatable/equatable.dart';

const String hourly = 'Hourly';
const String weekly = 'Weekly';
const String monthly = 'Monthly';
const String hourly_short = 'Hr';
const String weekly_short = 'Wk';
const String monthly_short = 'Mth';

class RateTypes extends Equatable {
  const RateTypes(String type) : _type = type;

  final String _type;

  String get type => _type;

  String toShortString() {
    if (type == hourly) {
      return hourly_short;
    } else if (type == weekly) {
      return weekly_short;
    } else {
      return monthly_short;
    }
  }

  int toIndex() {
    return types.indexOf(RateTypes(type));
  }

  @override
  String toString() => _type;

  @override
  List<Object> get props => [_type];

  static const RateTypes HOURLY = RateTypes(hourly);
  static const RateTypes WEEKLY = RateTypes(weekly);
  static const RateTypes MONTHLY = RateTypes(monthly);

  static List<RateTypes> get types => const [
        HOURLY,
        WEEKLY,
        MONTHLY,
      ];

  static RateTypes fromIndex(int rateTypeSelction) {
    return types[rateTypeSelction];
  }
}
