import 'package:equatable/equatable.dart';

const String online = 'Online';
const String private = 'Private';
const String groupString = 'Group';

class ClassFormat extends Equatable {
  const ClassFormat(String format) : _format = format;
  final String _format;

  String get type => _format;

  int toIndex() {
    return formats.indexOf(ClassFormat(type));
  }

  @override
  String toString() => _format;

  @override
  List<Object> get props => [_format];

  static const ClassFormat ONLINE = ClassFormat(online);
  static const ClassFormat PRIVATE = ClassFormat(private);
  static const ClassFormat GROUP = ClassFormat(groupString);

  static List<ClassFormat> get formats => const [
        ONLINE,
        PRIVATE,
        GROUP,
      ];

  static List<ClassFormat> fromIndices(List<int> classFormatSelection) {
    return classFormatSelection.map((e) => formats[e]).toList();
  }
}
