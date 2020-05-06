import 'package:equatable/equatable.dart';

abstract class Location extends Equatable {
  const Location({String location}) : _location = location;

  final String _location;
  @override
  List<Object> get props => [_location];

  @override
  String toString() => _location;
}
