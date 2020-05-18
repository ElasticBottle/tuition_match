import 'package:equatable/equatable.dart';

const String male = 'Male';
const String female = 'Female';

class Gender extends Equatable {
  const Gender(String gender) : _gender = gender;

  final String _gender;

  String get gender => _gender;

  int toIndex() {
    return genders.indexOf(Gender(_gender));
  }

  @override
  String toString() => _gender;

  @override
  List<Object> get props => [_gender];

  static const Gender MALE = Gender(male);
  static const Gender FEMALE = Gender(female);

  static List<Gender> get genders => const [MALE, FEMALE];

  static List<int> toIndices(List<String> values) {
    return values
        .map(
          (e) => genders.indexOf(Gender(e)),
        )
        .toList();
  }

  static List<Gender> fromIndices(List<int> value) {
    return value.map((e) => genders[e]).toList();
  }

  // static int toIndex(String value) {
  //   return genders.indexOf(Gender(value));
  // }

  static Gender fromIndex(int genderSelection) {
    return genders[genderSelection];
  }
}
