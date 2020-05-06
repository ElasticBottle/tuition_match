import 'package:equatable/equatable.dart';

class ClassFormat extends Equatable {
  const ClassFormat._(this._format);
  final String _format;

  static const ClassFormat ONLINE = ClassFormat._('Online');
  static const ClassFormat PRIVATE = ClassFormat._('Private');
  static const ClassFormat GROUP = ClassFormat._('Group');

  static List<ClassFormat> get formats => const [
        ONLINE,
        PRIVATE,
        GROUP,
      ];

  static List<int> toIndices(List<String> value) {
    return value
        .map(
          (e) => formats.indexOf(ClassFormat._(e)),
        )
        .toList();
  }

  static List<ClassFormat> fromIndices(List<int> classFormatSelection) {
    return classFormatSelection.map((e) => formats[e]).toList();
  }

  @override
  String toString() => _format;

  @override
  List<Object> get props => [_format];
}
