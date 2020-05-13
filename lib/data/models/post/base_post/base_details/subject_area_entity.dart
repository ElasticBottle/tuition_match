import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/subject_area.dart';

class SubjectAreaEntity extends SubjectArea implements EntityBase<SubjectArea> {
  const SubjectAreaEntity(String subject) : super(subject);

  factory SubjectAreaEntity.fromString(String subject) {
    return SubjectAreaEntity(subject);
  }

  factory SubjectAreaEntity.fromDomainEntity(SubjectArea subject) {
    return SubjectAreaEntity(subject.subject);
  }

  @override
  SubjectArea toDomainEntity() {
    return SubjectArea(subject);
  }
}
