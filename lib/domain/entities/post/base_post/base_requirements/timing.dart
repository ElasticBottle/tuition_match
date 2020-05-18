import 'package:equatable/equatable.dart';

class Timing extends Equatable {
  const Timing({String timing}) : _timing = timing;

  final String _timing;

  String get time => _timing;

  @override
  List<Object> get props => [_timing];

  @override
  String toString() => _timing;
}
