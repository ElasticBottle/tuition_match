// enum Gender {
//   male,
//   female,
// }

class Gender {
  const Gender();
  static const String MALE = 'Male';
  static const String FEMALE = 'Female';

  static List<String> get genders => const [MALE, FEMALE];

  static Map<String, bool> get asMap => const {
        MALE: true,
        FEMALE: true,
      };
}
