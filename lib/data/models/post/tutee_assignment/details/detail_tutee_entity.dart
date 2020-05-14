import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_details/date_details_entity.dart';
import 'package:cotor/data/models/post/base_post/base_details/level_entity.dart';
import 'package:cotor/data/models/post/base_post/base_details/subject_area_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/details/additional_remarks_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/details/grade_records_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/details_tutee.dart';

class DetailsTuteeEntity extends DetailsTutee
    implements EntityBase<DetailsTutee> {
  const DetailsTuteeEntity({
    AdditionalRemarksEntity additionalRemarks,
    DateDetailsEntity dateDetails,
    GradeRecordsEntity gradeRecords,
    List<LevelEntity> levels,
    List<SubjectAreaEntity> subjects,
  })  : _additionalRemarks = additionalRemarks,
        _dateDetails = dateDetails,
        _gradeRecords = gradeRecords,
        _levels = levels,
        _subjects = subjects,
        super(
          additionalRemarks: additionalRemarks,
          dateDetails: dateDetails,
          gradeRecords: gradeRecords,
          levels: levels,
          subjects: subjects,
        );

  factory DetailsTuteeEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return DetailsTuteeEntity(
      additionalRemarks:
          AdditionalRemarksEntity.fromString(json[ADDITIONAL_REMARKS]),
      dateDetails: DateDetailsEntity.fromJson(json[DATE_DETAILS]),
      gradeRecords: GradeRecordsEntity.fromJson(json[GRADE_RECORDS]),
      levels: json[LEVELS]
          .cast<String>()
          .map<LevelEntity>((String e) => LevelEntity.fromShortString(e))
          .toList(),
      subjects: json[SUBJECTS]
          .cast<String>()
          .map<SubjectAreaEntity>(
              (String e) => SubjectAreaEntity.fromShortString(e))
          .toList(),
    );
  }

  factory DetailsTuteeEntity.fromFirebaseMap(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return DetailsTuteeEntity(
      additionalRemarks:
          AdditionalRemarksEntity.fromString(json[ADDITIONAL_REMARKS]),
      dateDetails: DateDetailsEntity.fromFirebaseMap(json[DATE_DETAILS]),
      gradeRecords: GradeRecordsEntity.fromJson(json[GRADE_RECORDS]),
      levels: json[LEVELS]
          .entries
          .map<LevelEntity>((MapEntry<String, dynamic> e) =>
              LevelEntity.fromShortString(e.key))
          .toList(),
      subjects: json[SUBJECTS]
          .entries
          .map<SubjectAreaEntity>((MapEntry<String, dynamic> e) =>
              SubjectAreaEntity.fromShortString(e.key))
          .toList(),
    );
  }
  factory DetailsTuteeEntity.fromDomainEntity(DetailsTutee entity) {
    return DetailsTuteeEntity(
      additionalRemarks:
          AdditionalRemarksEntity.fromDomainEntity(entity.additionalRemarks),
      dateDetails: DateDetailsEntity.fromDomainEntity(entity.dateDetails),
      gradeRecords: GradeRecordsEntity.fromDomainEntity(entity.gradeRecords),
      levels:
          entity.levels.map((e) => LevelEntity.fromDomainEntity(e)).toList(),
      subjects: entity.subjects
          .map(
            (e) => SubjectAreaEntity.fromDomainEntity(e),
          )
          .toList(),
    );
  }

  final AdditionalRemarksEntity _additionalRemarks;
  final DateDetailsEntity _dateDetails;
  final GradeRecordsEntity _gradeRecords;
  final List<LevelEntity> _levels;
  final List<SubjectAreaEntity> _subjects;

  @override
  AdditionalRemarksEntity get additionalRemarks => _additionalRemarks;

  @override
  DateDetailsEntity get dateDetails => _dateDetails;

  @override
  GradeRecordsEntity get gradeRecords => _gradeRecords;

  @override
  List<LevelEntity> get levels => _levels;

  @override
  List<SubjectAreaEntity> get subjects => _subjects;

  @override
  DetailsTutee toDomainEntity() {
    return DetailsTutee(
        additionalRemarks: additionalRemarks.toDomainEntity(),
        dateDetails: dateDetails.toDomainEntity(),
        gradeRecords: gradeRecords.toDomainEntity(),
        levels: levels.map((e) => e.toDomainEntity()).toList(),
        subjects: subjects.map((e) => e.toDomainEntity()).toList());
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      DATE_DETAILS: dateDetails.toJson(),
      ADDITIONAL_REMARKS: additionalRemarks.toString(),
      GRADE_RECORDS: gradeRecords.toJson(),
      LEVELS: levels.map((e) => e.toShortString()).toList(),
      SUBJECTS: subjects.map((e) => e.toShortString()).toList(),
    };
  }

  Map<String, dynamic> toFirebaseMap({bool isNew, bool freeze = false}) {
    return <String, dynamic>{
      DATE_DETAILS: dateDetails.toFirebaseMap(isNew: isNew, freeze: freeze),
      GRADE_RECORDS: gradeRecords.toJson(),
      LEVELS: Map<String, dynamic>.fromIterable(
        levels,
        key: (dynamic element) => element.toShortString(),
        value: (dynamic element) => 1,
      ),
      SUBJECTS: Map<String, dynamic>.fromIterable(
        subjects,
        key: (dynamic element) => element.toShortString(),
        value: (dynamic element) => 1,
      ),
      ADDITIONAL_REMARKS: additionalRemarks.toString(),
    };
  }

  @override
  String toString() => ''' DetailsTuteeEntity(
      additionalRemarks: $additionalRemarks,
      dateDetails: $dateDetails,
      levels: $levels,
      subjects: $subjects,
      gradeRecords: $gradeRecords,
    )''';
}
