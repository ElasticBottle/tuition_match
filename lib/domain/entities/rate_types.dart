class RateTypes {
  const RateTypes();
  static const String HOURLY = 'Hourly';
  static const String WEEKLY = 'Weekly';
  static const String MONTHLY = 'Monthly';

  static List<String> get types => const [
        HOURLY,
        WEEKLY,
        MONTHLY,
      ];
}
// enum RateType {
//   hourly,
//   weekly,
//   monthly,
// }
