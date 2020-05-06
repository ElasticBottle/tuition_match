import 'package:equatable/equatable.dart';

class Gender extends Equatable {
  const Gender._(this._gender);
  final String _gender;
  static const Gender MALE = Gender._('Male');
  static const Gender FEMALE = Gender._('Female');

  static List<Gender> get genders => const [MALE, FEMALE];

  static List<int> toIndices(List<String> values) {
    return values
        .map(
          (e) => genders.indexOf(Gender._(e)),
        )
        .toList();
  }

  static List<Gender> fromIndices(List<int> value) {
    return value.map((e) => genders[e]).toList();
  }

  static int toIndex(String value) {
    return genders.indexOf(Gender._(value));
  }

  static Gender fromIndex(int genderSelection) {
    return genders[genderSelection];
  }

  @override
  String toString() => _gender;

  @override
  List<Object> get props => [_gender];
}
