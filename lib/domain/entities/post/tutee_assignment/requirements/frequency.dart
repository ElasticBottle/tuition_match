import 'package:equatable/equatable.dart';

abstract class Frequency extends Equatable {
  const Frequency({String freq}) : _freq = freq;
  final String _freq;

  @override
  List<Object> get props => [_freq];

  @override
  String toString() => _freq;
}
