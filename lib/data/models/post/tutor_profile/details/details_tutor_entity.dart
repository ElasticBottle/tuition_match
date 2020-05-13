import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_details/date_details_entity.dart';
import 'package:cotor/data/models/post/base_post/base_details/level_entity.dart';
import 'package:cotor/data/models/post/base_post/base_details/subject_area_entity.dart';
import 'package:cotor/data/models/post/base_post/tutor_occupation_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/details/qualifications_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/details/selling_points_entity.dart';
import 'package:cotor/domain/entities/post/tutor_profile/details/details_tutor.dart';

class DetailsTutorEntity extends DetailsTutor
    implements EntityBase<DetailsTutor> {
  const DetailsTutorEntity({
    DateDetailsEntity dateDetails,
    List<LevelEntity> levelsTaught,
    List<SubjectAreaEntity> subjectsTaught,
    TutorOccupationEntity tutorOccupation,
    QualificationsEntity qualification,
    SellingPointsEntity sellingPoints,
  })  : _dateDetails = dateDetails,
        _levelsTaught = levelsTaught,
        _tutorOccupation = tutorOccupation,
        _qualification = qualification,
        _sellingPoints = sellingPoints,
        _subjectsTaught = subjectsTaught,
        super(
          dateDetails: dateDetails,
          levelsTaught: levelsTaught,
          tutorOccupation: tutorOccupation,
          qualification: qualification,
          sellingPoints: sellingPoints,
          subjectsTaught: subjectsTaught,
        );

  factory DetailsTutorEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return DetailsTutorEntity(
      dateDetails: DateDetailsEntity.fromJson(json[DATE_DETAILS]),
      levelsTaught:
          json[LEVELS_TAUGHT].cast<String>().map<LevelEntity>((String e) {
        return LevelEntity.fromShortString(e);
      }).toList(),
      subjectsTaught: json[SUBJECTS_TAUGHT]
          .cast<String>()
          .map<SubjectAreaEntity>((String e) => SubjectAreaEntity.fromString(e))
          .toList(),
      qualification: QualificationsEntity.fromString(json[QUALIFICATIONS]),
      tutorOccupation: TutorOccupationEntity.fromString(json[TUTOR_OCCUPATION]),
      sellingPoints: SellingPointsEntity.fromString(json[SELLING_POINTS]),
    );
  }

  factory DetailsTutorEntity.fromFirebaseMap(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return DetailsTutorEntity(
      dateDetails: DateDetailsEntity.fromFirebaseMap(json[DATE_DETAILS]),
      levelsTaught: json[LEVELS_TAUGHT]
          .entries
          .map<LevelEntity>((MapEntry<String, dynamic> e) =>
              LevelEntity.fromShortString(e.key))
          .toList(),
      subjectsTaught: json[SUBJECTS_TAUGHT]
          .entries
          .map<SubjectAreaEntity>((MapEntry<String, dynamic> e) =>
              SubjectAreaEntity.fromString(e.key))
          .toList(),
      qualification: QualificationsEntity.fromString(json[QUALIFICATIONS]),
      tutorOccupation: TutorOccupationEntity.fromString(json[TUTOR_OCCUPATION]),
      sellingPoints: SellingPointsEntity.fromString(json[SELLING_POINTS]),
    );
  }

  factory DetailsTutorEntity.fromDomainEntity(DetailsTutor entity) {
    return DetailsTutorEntity(
      dateDetails: DateDetailsEntity.fromDomainEntity(entity.dateDetails),
      levelsTaught: entity.levelsTaught
          .map((e) => LevelEntity.fromDomainEntity(e))
          .toList(),
      subjectsTaught: entity.subjectsTaught
          .map((e) => SubjectAreaEntity.fromDomainEntity(e))
          .toList(),
      tutorOccupation:
          TutorOccupationEntity.fromDomainEntity(entity.occupation),
      qualification:
          QualificationsEntity.fromDomainEntity(entity.qualification),
      sellingPoints: SellingPointsEntity.fromDomainEntity(entity.sellingPoints),
    );
  }

  final DateDetailsEntity _dateDetails;
  final List<LevelEntity> _levelsTaught;
  final List<SubjectAreaEntity> _subjectsTaught;
  final TutorOccupationEntity _tutorOccupation;
  final QualificationsEntity _qualification;
  final SellingPointsEntity _sellingPoints;

  @override
  DateDetailsEntity get dateDetails => _dateDetails;

  @override
  List<LevelEntity> get levelsTaught => _levelsTaught;

  @override
  SellingPointsEntity get sellingPoints => _sellingPoints;

  @override
  TutorOccupationEntity get occupation => _tutorOccupation;

  @override
  QualificationsEntity get qualification => _qualification;

  @override
  List<SubjectAreaEntity> get subjectsTaught => _subjectsTaught;

  @override
  DetailsTutor toDomainEntity() {
    return DetailsTutor(
      dateDetails: dateDetails.toDomainEntity(),
      levelsTaught: levelsTaught.map((e) => e.toDomainEntity()).toList(),
      subjectsTaught: subjectsTaught.map((e) => e.toDomainEntity()).toList(),
      tutorOccupation: occupation.toDomainEntity(),
      qualification: qualification.toDomainEntity(),
      sellingPoints: sellingPoints.toDomainEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      DATE_DETAILS: dateDetails.toJson(),
      LEVELS_TAUGHT: levelsTaught.map((e) => e.toShortString()).toList(),
      SUBJECTS_TAUGHT: subjectsTaught.map((e) => e.toString()).toList(),
      TUTOR_OCCUPATION: occupation.toString(),
      QUALIFICATIONS: qualification.toString(),
      SELLING_POINTS: sellingPoints.toString()
    };
  }

  Map<String, dynamic> toFirebaseMap({bool isNew}) {
    // TODO(ElasticBottle): verify that it actually works
    return <String, dynamic>{
      DATE_DETAILS: dateDetails.toFirebaseMap(isNew: isNew),
      LEVELS_TAUGHT: Map<String, dynamic>.fromIterable(
        levelsTaught,
        key: (dynamic element) => element.toShortString(),
        value: (dynamic element) => 1,
      ),
      SUBJECTS_TAUGHT: Map<String, dynamic>.fromIterable(
        subjectsTaught,
        key: (dynamic element) => element.toString(),
        value: (dynamic element) => 1,
      ),
      TUTOR_OCCUPATION: occupation.toString(),
      QUALIFICATIONS: qualification.toString(),
      SELLING_POINTS: sellingPoints.toString()
    };
  }

  @override
  String toString() {
    return '''DetailsTutorEntity(
      dateDetails: $dateDetails,
      levelsTaught: $levelsTaught, 
      subjectsTaught: $subjectsTaught, 
      tutorOccupation: $occupation, 
      qualification: $qualification, 
      sellingPoints: $sellingPoints
    )''';
  }
}
