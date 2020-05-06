import 'package:equatable/equatable.dart';

class Level extends Equatable {
  const Level._(this._lvl);
  final String _lvl;

  static const Level PRESCHOOL = Level._('Pre-School');
  static const Level K1 = Level._('K1');
  static const Level K2 = Level._('K2');
  static const Level PRI1 = Level._('Primary 1');
  static const Level PRI2 = Level._('Primary 2');
  static const Level PRI3 = Level._('Primary 3');
  static const Level PRI4 = Level._('Primary 4');
  static const Level PRI5 = Level._('Primary 5');
  static const Level PRI6 = Level._('Primary 6');
  static const Level SEC1 = Level._('Secondary 1');
  static const Level SEC2 = Level._('Secondary 2');
  static const Level SEC3 = Level._('Secondary 3');
  static const Level SEC4 = Level._('Secondary 4');
  static const Level SEC5 = Level._('Secondary 5');
  static const Level JC1 = Level._('JC 1');
  static const Level JC2 = Level._('JC 2');
  static const Level IB1 = Level._('IB 1');
  static const Level IB2 = Level._('IB 2');
  static const Level POLY = Level._('Polytechnic');
  static const Level UNI = Level._('University');
  static const Level OTHER = Level._('Other');

  static List<Level> get preschool => const [PRESCHOOL];
  static List<Level> get kindergarden => const [K1, K2];
  static List<Level> get pri => const [
        PRI1,
        PRI2,
        PRI3,
        PRI4,
        PRI5,
        PRI6,
      ];
  static List<Level> get sec => const [
        SEC1,
        SEC2,
        SEC3,
        SEC4,
        SEC5,
      ];
  static List<Level> get jc => const [JC1, JC2];
  static List<Level> get ib => const [IB1, IB2];
  static List<Level> get poly => const [POLY];
  static List<Level> get uni => const [UNI];
  static List<Level> get all => const [
        PRESCHOOL,
        K1,
        K2,
        PRI1,
        PRI2,
        PRI3,
        PRI4,
        PRI5,
        PRI6,
        SEC1,
        SEC2,
        SEC3,
        SEC4,
        SEC5,
        JC1,
        JC2,
        IB1,
        IB2,
        POLY,
        UNI,
        OTHER,
      ];

  static List<int> toIndices(List<String> value) {
    return value
        .map(
          (e) => Level.all.indexOf(Level._(e)),
        )
        .toList();
  }

  static List<Level> fromIndices(List<int> levels) {
    return levels.map((e) => Level.all[e]).toList();
  }

  @override
  String toString() => _lvl;
  @override
  List<Object> get props => [_lvl];
}
