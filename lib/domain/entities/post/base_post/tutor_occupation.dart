import 'package:equatable/equatable.dart';

const String partTime = 'Part Time';
const String fullTime = 'Full Time';
const String moe = 'MOE';

class TutorOccupation extends Equatable {
  const TutorOccupation(String occupation) : _occupation = occupation;

  final String _occupation;

  String get occupation => _occupation;

  @override
  List<Object> get props => [_occupation];

  @override
  String toString() => _occupation;

  static const TutorOccupation PART_TIME = TutorOccupation(partTime);
  static const TutorOccupation FULL_TIME = TutorOccupation(fullTime);
  static const TutorOccupation MOE = TutorOccupation(moe);

  static List<TutorOccupation> get occupations => const [
        PART_TIME,
        FULL_TIME,
        MOE,
      ];

  static int toIndex(String value) {
    return TutorOccupation.occupations.indexOf(TutorOccupation(value));
  }

  static TutorOccupation fromIndex(int tutorOccupation) {
    return occupations[tutorOccupation];
  }

  static List<int> toIndices(List<String> value) {
    return value
        .map(
          (e) => occupations.indexOf(TutorOccupation(e)),
        )
        .toList();
  }

  static List<TutorOccupation> fromIndices(List<int> value) {
    return value.map((e) => occupations[e]).toList();
  }
}
