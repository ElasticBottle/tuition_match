import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/gender.dart';

class GenderEntity extends Gender implements EntityBase<Gender> {
  const GenderEntity(String gender) : super(gender);

  factory GenderEntity.fromShortString(String gender) {
    if (gender == 'm') {
      return GenderEntity(Gender.MALE.toString());
    } else if (gender == 'f') {
      return GenderEntity(Gender.FEMALE.toString());
    } else
      return GenderEntity(gender);
  }

  factory GenderEntity.fromDomainEntity(Gender entity) {
    return GenderEntity(entity.gender);
  }

  @override
  Gender toDomainEntity() {
    return Gender(gender);
  }

  String toShortString() {
    if (gender == male) {
      return 'm';
    } else {
      return 'f';
    }
  }
}
