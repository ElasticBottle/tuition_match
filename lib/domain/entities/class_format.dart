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
}
// enum ClassFormat {
//   online,
//   private,
//   group,
// }
