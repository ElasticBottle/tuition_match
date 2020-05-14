import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/frequency.dart';

class FrequencyEntity extends Frequency implements EntityBase<Frequency> {
  const FrequencyEntity({String freq}) : super(freq: freq);

  factory FrequencyEntity.fromString(String freq) {
    return FrequencyEntity(freq: freq);
  }
  factory FrequencyEntity.fromDomainEntity(Frequency entity) {
    return FrequencyEntity(freq: entity.freq);
  }

  @override
  Frequency toDomainEntity() {
    return Frequency(freq: freq);
  }
}
