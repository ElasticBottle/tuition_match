import 'package:equatable/equatable.dart';

class ClassFormat extends Equatable {
  const ClassFormat(String format) : _format = format;
  final String _format;

  String get type => _format;

  @override
  String toString() => _format;

  @override
  List<Object> get props => [_format];

  static const ClassFormat ONLINE = ClassFormat('Online');
  static const ClassFormat PRIVATE = ClassFormat('Private');
  static const ClassFormat GROUP = ClassFormat('Group');

  static List<ClassFormat> get formats => const [
        ONLINE,
        PRIVATE,
        GROUP,
      ];

  static List<int> toIndices(List<String> value) {
    return value
        .map(
          (e) => formats.indexOf(ClassFormat(e)),
        )
        .toList();
  }

  static List<ClassFormat> fromIndices(List<int> classFormatSelection) {
    return classFormatSelection.map((e) => formats[e]).toList();
  }
}
