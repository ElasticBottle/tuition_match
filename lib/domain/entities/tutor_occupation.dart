class TutorOccupation {
  const TutorOccupation();
  static const String PART_TIME = 'Part Time';
  static const String FULL_TIME = 'Full Time';
  static const String MOE = 'MOE';

  static List<String> get occupations => const [
        PART_TIME,
        FULL_TIME,
        MOE,
      ];

  static int toIndex(String value) {
    return TutorOccupation.occupations.indexOf(value);
  }

  static String fromIndex(int tutorOccupation) {
    return occupations[tutorOccupation];
  }

  static List<int> toIndices(List<String> value) {
    return value.map((e) => occupations.indexOf(e)).toList();
  }

  static List<String> fromIndices(List<int> value) {
    return value.map((e) => occupations[e]).toList();
  }
}
// enum TutorOccupation {
//   partTime,
//   fullTime,
//   moe,
// }
