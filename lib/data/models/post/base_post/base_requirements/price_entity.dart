import 'package:cotor/data/models/post/base_post/base_requirements/rate_types_entity.dart';

import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/price.dart';

class PriceEntity extends Price implements EntityBase<Price> {
  const PriceEntity({
    double maxRate,
    double minRate,
    double proposedRate,
    RateTypesEntity rateType,
  })  : _rateTypes = rateType,
        super(
          maxRate: maxRate,
          minRate: minRate,
          proposedRate: proposedRate,
          rateType: rateType,
        );

  factory PriceEntity.fromJson(Map<String, dynamic> json) {
    return PriceEntity(
      maxRate: json[MAX_RATE].toDouble(),
      minRate: json[MIN_RATE].toDouble(),
      proposedRate: json[PROPOSED_RATE].toDouble(),
      rateType: RateTypesEntity.fromShortString(json[RATE_TYPE]),
    );
  }

  factory PriceEntity.fromDomainEntity(Price price) {
    return PriceEntity(
        maxRate: price.maxRate,
        minRate: price.minRate,
        proposedRate: price.proposedRate,
        rateType: RateTypesEntity.fromDomainEntity(price.rateType));
  }

  final RateTypesEntity _rateTypes;

  @override
  RateTypesEntity get rateType => _rateTypes;

  @override
  Price toDomainEntity() {
    return Price(
      rateType: rateType.toDomainEntity(),
      maxRate: maxRate,
      minRate: minRate,
      proposedRate: proposedRate,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      MAX_RATE: maxRate ?? 0.0,
      MIN_RATE: minRate ?? 0.0,
      PROPOSED_RATE: proposedRate ?? 0.0,
      RATE_TYPE: rateType.toShortString(),
    };
  }

  @override
  String toString() {
    return 'PriceEntity(maxRate: $maxRate, minRate: $minRate, proposedRate: $proposedRate, rateType: $rateType)';
  }
}
