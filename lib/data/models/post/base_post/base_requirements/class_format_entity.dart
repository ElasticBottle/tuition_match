import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/class_format.dart';

const String onlineShort = 'On';
const String privateShort = 'Pr';
const String groupShort = 'Gr';

class ClassFormatEntity extends ClassFormat implements EntityBase<ClassFormat> {
  const ClassFormatEntity(String format) : super(format);

  factory ClassFormatEntity.fromShortString(String format) {
    switch (format) {
      case onlineShort:
        return ClassFormatEntity(online);
      case privateShort:
        return ClassFormatEntity(private);
      case groupShort:
        return ClassFormatEntity(groupString);
      default:
        return ClassFormatEntity(format);
    }
  }

  factory ClassFormatEntity.fromDomainEntity(ClassFormat format) {
    return ClassFormatEntity(format.type);
  }

  String toShortString() {
    switch (type) {
      case online:
        return onlineShort;
      case private:
        return privateShort;
      case groupString:
        return groupShort;
      default:
        return type;
    }
  }

  @override
  ClassFormat toDomainEntity() {
    return ClassFormat(type);
  }
}
