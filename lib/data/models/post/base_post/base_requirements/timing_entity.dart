import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/timing.dart';

class TimingEntity extends Timing implements EntityBase<Timing> {
  const TimingEntity({String timing}) : super(timing: timing);

  factory TimingEntity.fromString(String timing) {
    return TimingEntity(timing: timing);
  }
  factory TimingEntity.fromDomainEntity(Timing timing) {
    return TimingEntity(timing: timing.time);
  }

  @override
  Timing toDomainEntity() {
    return Timing(timing: time);
  }
}
