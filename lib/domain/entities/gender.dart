// enum Gender {
//   male,
//   female,
// }

class Gender {
  const Gender();
  static const String MALE = 'Male';
  static const String FEMALE = 'Female';

  static List<String> get genders => const [MALE, FEMALE];

  static List<int> toIndices(List<String> values) {
    return values.map((e) => genders.indexOf(e)).toList();
  }

  static int toIndex(String value) {
    return genders.indexOf(value);
  }

  static String fromIndex(int genderSelection) {
    return genders[genderSelection];
  }
}
