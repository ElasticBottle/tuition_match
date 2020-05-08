import 'package:equatable/equatable.dart';

class Frequency extends Equatable {
  const Frequency({String freq}) : _freq = freq;

  final String _freq;

  String get freq => _freq;

  @override
  List<Object> get props => [_freq];

  @override
  String toString() => _freq;
}
