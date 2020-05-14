import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/tutor_occupation.dart';

const String partTimeShort = 'PT';
const String fullTimeShort = 'FT';
const String moeShort = 'MOE';

class TutorOccupationEntity extends TutorOccupation
    implements EntityBase<TutorOccupation> {
  const TutorOccupationEntity(String occupation) : super(occupation);

  factory TutorOccupationEntity.fromShortString(String occ) {
    switch (occ) {
      case partTimeShort:
        return TutorOccupationEntity(partTime);
      case fullTimeShort:
        return TutorOccupationEntity(fullTime);
      case moeShort:
        return TutorOccupationEntity(moe);
      default:
        return TutorOccupationEntity(occ);
    }
  }

  factory TutorOccupationEntity.fromDomainEntity(TutorOccupation entity) {
    return TutorOccupationEntity(entity.occupation);
  }

  String toShortString() {
    switch (occupation) {
      case partTime:
        return partTimeShort;
      case fullTime:
        return fullTimeShort;
      case moe:
        return moeShort;
      default:
        return occupation;
    }
  }

  @override
  TutorOccupation toDomainEntity() {
    return TutorOccupation(occupation);
  }
}
