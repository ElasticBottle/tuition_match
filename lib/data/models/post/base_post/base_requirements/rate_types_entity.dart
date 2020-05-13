import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/rate_types.dart';

class RateTypesEntity extends RateTypes implements EntityBase<RateTypes> {
  const RateTypesEntity(String type) : super(type);

  factory RateTypesEntity.fromShortString(String rType) {
    if (rType == hourly_short) {
      return RateTypesEntity(hourly);
    } else if (rType == weekly_short) {
      return RateTypesEntity(weekly);
    } else if (rType == monthly_short) {
      return RateTypesEntity(monthly);
    } else {
      return RateTypesEntity(rType);
    }
  }

  factory RateTypesEntity.fromDomainEntity(RateTypes rType) {
    return RateTypesEntity(rType.type);
  }

  @override
  RateTypes toDomainEntity() {
    return RateTypes(type);
  }
}
