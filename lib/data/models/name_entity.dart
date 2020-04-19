import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:equatable/equatable.dart';

class NameEntity extends Equatable implements Name {
  const NameEntity({
    String firstName,
    String lastName,
  })  : _firstName = firstName,
        _lastName = lastName;

  factory NameEntity.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return NameEntity();
    }
    return NameEntity(
      firstName: json[FIRSTNAME],
      lastName: json[LASTNAME],
    );
  }

  factory NameEntity.fromDomainEntity(Name name) {
    if (name == null) {
      return null;
    }
    return NameEntity(
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FIRSTNAME: _firstName,
      LASTNAME: _lastName,
    };
  }

  Name toDomainEntity() {
    return NameEntity(
      firstName: _firstName,
      lastName: _lastName,
    );
  }

  @override
  String toString() => _firstName + ' ' + _lastName;

  @override
  List<Object> get props => [_firstName, _lastName];
}
