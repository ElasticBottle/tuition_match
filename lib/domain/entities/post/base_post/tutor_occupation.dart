import 'package:equatable/equatable.dart';

class TutorOccupation extends Equatable {
  const TutorOccupation._(this._occupation);
  final String _occupation;
  static const TutorOccupation PART_TIME = TutorOccupation._('Part Time');
  static const TutorOccupation FULL_TIME = TutorOccupation._('Full Time');
  static const TutorOccupation MOE = TutorOccupation._('MOE');

  static List<TutorOccupation> get occupations => const [
        PART_TIME,
        FULL_TIME,
        MOE,
      ];

  static int toIndex(String value) {
    return TutorOccupation.occupations.indexOf(TutorOccupation._(value));
  }

  static TutorOccupation fromIndex(int tutorOccupation) {
    return occupations[tutorOccupation];
  }

  static List<int> toIndices(List<String> value) {
    return value
        .map(
          (e) => occupations.indexOf(TutorOccupation._(e)),
        )
        .toList();
  }

  static List<TutorOccupation> fromIndices(List<int> value) {
    return value.map((e) => occupations[e]).toList();
  }

  @override
  List<Object> get props => [_occupation];
}
