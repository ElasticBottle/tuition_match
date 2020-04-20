import 'package:cotor/domain/entities/name.dart';
import 'package:equatable/equatable.dart';

class NameModel extends Equatable implements Name {
  const NameModel({
    String firstName,
    String lastName,
  })  : _firstName = firstName,
        _lastName = lastName;

  factory NameModel.empty() {
    return NameModel(
      firstName: '',
      lastName: '',
    );
  }
  factory NameModel.fromDomainEntity(Name name) {
    if (name == null) {
      return null;
    }
    return NameModel(
      firstName: name.firstName,
      lastName: name.lastName,
    );
  }

  final String _firstName;
  final String _lastName;

  @override
  String get firstName => _firstName;
  @override
  String get lastName => _lastName;

  Name toDomainEntity() {
    return NameModel(
      firstName: _firstName,
      lastName: _lastName,
    );
  }

  @override
  String toString() => _firstName + ' ' + _lastName;

  @override
  List<Object> get props => [_firstName, _lastName];
}
