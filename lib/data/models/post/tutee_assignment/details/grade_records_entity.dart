import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/tutee_assignment/details/grade_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/grade_records.dart';

class GradeRecordsEntity extends GradeRecords
    implements EntityBase<GradeRecords> {
  const GradeRecordsEntity({
    GradeEntity start,
    GradeEntity end,
  })  : _start = start,
        _end = end,
        super(
          start: start,
          end: end,
        );

  factory GradeRecordsEntity.fromJson(Map<String, dynamic> json) {
    return GradeRecordsEntity(
      start: GradeEntity.fromShortString(json[INITIAL_GRADE]),
      end: GradeEntity.fromShortString(json[FINAL_GRADE]),
    );
  }

  factory GradeRecordsEntity.fromDomainEntity(GradeRecords entity) {
    return GradeRecordsEntity(
      end: GradeEntity.fromDomainEntity(entity.end),
      start: GradeEntity.fromDomainEntity(entity.start),
    );
  }

  final GradeEntity _start;
  final GradeEntity _end;

  @override
  GradeEntity get start => _start;
  @override
  GradeEntity get end => _end;

  @override
  GradeRecords toDomainEntity() {
    return GradeRecords(
      start: start.toDomainEntity(),
      end: end?.toDomainEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      INITIAL_GRADE: start.toShortString(),
      FINAL_GRADE: end?.toShortString(),
    };
  }

  @override
  String toString() => '''GradeRecordsEntity( start: $start, end: $end, )''';
}
