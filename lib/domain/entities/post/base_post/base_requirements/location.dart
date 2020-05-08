import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location({String location}) : _location = location;

  final String _location;

  String get loc => _location;

  @override
  List<Object> get props => [_location];

  @override
  String toString() => _location;
}
