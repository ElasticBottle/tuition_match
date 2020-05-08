class Timing {
  const Timing({String timing}) : _timing = timing;

  final String _timing;

  String get time => _timing;

  List<Object> get props => [_timing];

  @override
  String toString() => _timing;
}
