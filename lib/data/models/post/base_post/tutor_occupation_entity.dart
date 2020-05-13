import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/tutor_occupation.dart';

class TutorOccupationEntity extends TutorOccupation
    implements EntityBase<TutorOccupation> {
  const TutorOccupationEntity(String occupation) : super(occupation);

  factory TutorOccupationEntity.fromString(String occ) {
    return TutorOccupationEntity(occ);
  }

  factory TutorOccupationEntity.fromDomainEntity(TutorOccupation entity) {
    return TutorOccupationEntity(entity.occupation);
  }

  @override
  TutorOccupation toDomainEntity() {
    return TutorOccupation(occupation);
  }
}
