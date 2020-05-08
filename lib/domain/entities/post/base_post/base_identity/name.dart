import 'package:equatable/equatable.dart';

class Name extends Equatable {
  const Name({
    String firstName,
    String lastName,
  })  : _firstName = firstName,
        _lastName = lastName;

  final String _firstName;
  final String _lastName;

  String get firstName => _firstName;
  String get lastName => _lastName;

  @override
  String toString() => _firstName + ' ' + _lastName;

  @override
  List<Object> get props => [_firstName, _lastName];
}
