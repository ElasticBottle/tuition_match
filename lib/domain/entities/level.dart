class Level {
  const Level();
  static const String PRESCHOOL = 'Pre-School';
  static const String K1 = 'K1';
  static const String K2 = 'K2';
  static const String PRI1 = 'Primary 1';
  static const String PRI2 = 'Primary 2';
  static const String PRI3 = 'Primary 3';
  static const String PRI4 = 'Primary 4';
  static const String PRI5 = 'Primary 5';
  static const String PRI6 = 'Primary 6';
  static const String SEC1 = 'Secondary 1';
  static const String SEC2 = 'Secondary 2';
  static const String SEC3 = 'Secondary 3';
  static const String SEC4 = 'Secondary 4';
  static const String SEC5 = 'Secondary 5';
  static const String JC1 = 'JC 1';
  static const String JC2 = 'JC 2';
  static const String IB1 = 'IB 1';
  static const String IB2 = 'IB 2';
  static const String POLY = 'Polytechnic';
  static const String UNI = 'University';
  static const String OTHER = 'Other';

  static List<String> get preschool => const [PRESCHOOL];
  static List<String> get kindergarden => const [K1, K2];
  static List<String> get pri => const [
        PRI1,
        PRI2,
        PRI3,
        PRI4,
        PRI5,
        PRI6,
      ];
  static List<String> get sec => const [
        SEC1,
        SEC2,
        SEC3,
        SEC4,
        SEC5,
      ];
  static List<String> get jc => const [JC1, JC2];
  static List<String> get ib => const [IB1, IB2];
  static List<String> get poly => const [POLY];
  static List<String> get uni => const [UNI];
  static List<String> get all => const [
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
    return value.map((e) => Level.all.indexOf(e)).toList();
  }

  static List<String> fromIndices(List<int> levels) {
    return levels.map((e) => Level.all[e]).toList();
  }

  static int toIndex(String e) {
    return all.indexOf(e);
  }
}
