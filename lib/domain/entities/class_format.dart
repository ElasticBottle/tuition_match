class ClassFormat {
  const ClassFormat();
  static const String ONLINE = 'Online';
  static const String PRIVATE = 'Private';
  static const String GROUP = 'Group';

  static List<String> get formats => const [
        ONLINE,
        PRIVATE,
        GROUP,
      ];

  static List<int> toIndices(List<String> value) {
    return value.map((e) => formats.indexOf(e)).toList();
  }

  static List<String> fromIndices(List<int> classFormatSelection) {
    return classFormatSelection.map((e) => formats[e]).toList();
  }
}
// enum ClassFormat {
//   online,
//   private,
//   group,
// }
