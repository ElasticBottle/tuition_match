import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/tutor_profile/details/qualifications.dart';

class QualificationsEntity extends Qualifications
    implements EntityBase<Qualifications> {
  const QualificationsEntity({String qualifications})
      : super(qualifications: qualifications);

  factory QualificationsEntity.fromString(String qual) {
    return QualificationsEntity(qualifications: qual);
  }

  factory QualificationsEntity.fromDomainEntity(Qualifications entity) {
    return QualificationsEntity(qualifications: entity.qualifications);
  }

  @override
  Qualifications toDomainEntity() {
    return Qualifications(qualifications: qualifications);
  }
}
