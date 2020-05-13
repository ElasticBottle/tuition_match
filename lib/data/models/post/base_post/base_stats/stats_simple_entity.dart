import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/post/base_post/base_stats/stats_simple.dart';

class StatsSimpleEntity extends StatsSimple implements EntityBase<StatsSimple> {
  const StatsSimpleEntity({
    int likeCount,
    int requestCount,
  }) : super(
          likeCount: likeCount,
          requestCount: requestCount,
        );
  factory StatsSimpleEntity.fromJson(Map<String, dynamic> json) {
    return StatsSimpleEntity(
      likeCount: json[LIKE_COUNT],
      requestCount: json[REQUEST_COUNT],
    );
  }

  factory StatsSimpleEntity.fromDomainEntity(StatsSimple entity) {
    return StatsSimpleEntity(
      likeCount: entity.likeCount,
      requestCount: entity.requestCount,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      LIKE_COUNT: likeCount,
      REQUEST_COUNT: requestCount,
    };
  }

  Map<String, dynamic> toFirebaseMap({bool isNew}) {
    return <String, dynamic>{
      LIKE_COUNT: isNew ? 0 : FieldValue,
      REQUEST_COUNT: isNew ? 0 : FieldValue,
    };
  }

  @override
  StatsSimple toDomainEntity() {
    return StatsSimple(
      likeCount: likeCount,
      requestCount: requestCount,
    );
  }

  @override
  String toString() =>
      'StatsSimpleEntity(likeCount: $likeCount, requestCount: $requestCount)';
}
