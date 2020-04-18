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
}
// enum TutorOccupation {
//   partTime,
//   fullTime,
//   moe,
// }
