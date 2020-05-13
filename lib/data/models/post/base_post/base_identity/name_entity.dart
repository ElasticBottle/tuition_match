import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/name.dart';

class NameEntity extends Name implements EntityBase<Name> {
  const NameEntity({
    String firstName,
    String lastName,
  }) : super(
          firstName: firstName,
          lastName: lastName,
        );

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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FIRSTNAME: firstName,
      LASTNAME: lastName,
    };
  }

  @override
  Name toDomainEntity() {
    return Name(firstName: firstName, lastName: lastName);
  }
}
