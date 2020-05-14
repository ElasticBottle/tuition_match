import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/class_format_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/location_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/price_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/timing_entity.dart';
import 'package:cotor/data/models/post/base_post/gender_entity.dart';
import 'package:cotor/data/models/post/base_post/tutor_occupation_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/requirements/frequency_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/requirements_tutee.dart';

class RequirementsTuteeEntity extends RequirementsTutee
    implements EntityBase<RequirementsTutee> {
  const RequirementsTuteeEntity({
    List<ClassFormatEntity> classFormat,
    FrequencyEntity freq,
    TimingEntity timing,
    LocationEntity loc,
    PriceEntity price,
    List<GenderEntity> tutorGenders,
    List<TutorOccupationEntity> tutorOccupations,
  })  : _classFormat = classFormat,
        _freq = freq,
        _timing = timing,
        _loc = loc,
        _price = price,
        _tutorGenders = tutorGenders,
        _tutorOccupations = tutorOccupations,
        super(
          classFormat: classFormat,
          freq: freq,
          timing: timing,
          location: loc,
          price: price,
          tutorGenders: tutorGenders,
          tutorOccupations: tutorOccupations,
        );

  factory RequirementsTuteeEntity.fromFirebaseMap(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return RequirementsTuteeEntity(
      classFormat: json[CLASS_FORMATS]
          .entries
          .map<ClassFormatEntity>(
            (MapEntry<String, dynamic> e) =>
                ClassFormatEntity.fromShortString(e.key),
          )
          .toList(),
      freq: FrequencyEntity.fromString(json[FREQ]),
      timing: TimingEntity.fromString(json[TIMING]),
      loc: LocationEntity.fromString(json[LOCATION]),
      price: PriceEntity.fromJson(json[PRICE]),
      tutorGenders: json[TUTOR_GENDER]
          .entries
          .map<GenderEntity>(
            (MapEntry<String, dynamic> e) =>
                GenderEntity.fromShortString(e.key),
          )
          .toList(),
      tutorOccupations: json[TUTOR_OCCUPATIONS]
          .entries
          .map<TutorOccupationEntity>(
            (MapEntry<String, dynamic> e) =>
                TutorOccupationEntity.fromShortString(e.key),
          )
          .toList(),
    );
  }
  factory RequirementsTuteeEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return RequirementsTuteeEntity(
      classFormat: json[CLASS_FORMATS]
          .cast<String>()
          .map<ClassFormatEntity>(
            (String e) => ClassFormatEntity.fromShortString(e),
          )
          .toList(),
      freq: FrequencyEntity.fromString(json[FREQ]),
      timing: TimingEntity.fromString(json[TIMING]),
      loc: LocationEntity.fromString(json[LOCATION]),
      price: PriceEntity.fromJson(json[PRICE]),
      tutorGenders: json[TUTOR_GENDER]
          .cast<String>()
          .map<GenderEntity>(
            (String e) => GenderEntity.fromShortString(e),
          )
          .toList(),
      tutorOccupations: json[TUTOR_OCCUPATIONS]
          .cast<String>()
          .map<TutorOccupationEntity>(
            (String e) => TutorOccupationEntity.fromShortString(e),
          )
          .toList(),
    );
  }
  factory RequirementsTuteeEntity.fromDomainEntity(RequirementsTutee entity) {
    return RequirementsTuteeEntity(
      classFormat: entity.classFormat
          .map((e) => ClassFormatEntity.fromDomainEntity(e))
          .toList(),
      freq: FrequencyEntity.fromDomainEntity(entity.freq),
      timing: TimingEntity.fromDomainEntity(entity.timing),
      loc: LocationEntity.fromDomainEntity(entity.location),
      price: PriceEntity.fromDomainEntity(entity.price),
      tutorGenders: entity.tutorGender
          .map((e) => GenderEntity.fromDomainEntity(e))
          .toList(),
      tutorOccupations: entity.tutorOccupation
          .map((e) => TutorOccupationEntity.fromDomainEntity(e))
          .toList(),
    );
  }

  final List<ClassFormatEntity> _classFormat;
  final FrequencyEntity _freq;
  final TimingEntity _timing;
  final LocationEntity _loc;
  final PriceEntity _price;
  final List<GenderEntity> _tutorGenders;
  final List<TutorOccupationEntity> _tutorOccupations;

  @override
  List<ClassFormatEntity> get classFormat => _classFormat;

  @override
  FrequencyEntity get freq => _freq;

  @override
  LocationEntity get location => _loc;

  @override
  PriceEntity get price => _price;

  @override
  TimingEntity get timing => _timing;

  @override
  List<GenderEntity> get tutorGender => _tutorGenders;

  @override
  List<TutorOccupationEntity> get tutorOccupation => _tutorOccupations;

  @override
  RequirementsTutee toDomainEntity() {
    return RequirementsTutee(
      classFormat: classFormat.map((e) => e.toDomainEntity()).toList(),
      freq: freq.toDomainEntity(),
      timing: timing.toDomainEntity(),
      location: location.toDomainEntity(),
      price: price.toDomainEntity(),
      tutorGenders: tutorGender.map((e) => e.toDomainEntity()).toList(),
      tutorOccupations: tutorOccupation.map((e) => e.toDomainEntity()).toList(),
    );
  }

  Map<String, dynamic> toFirebaseMap() {
    return <String, dynamic>{
      CLASS_FORMATS: Map<String, dynamic>.fromIterable(
        classFormat,
        key: (dynamic element) => element.toShortString(),
        value: (dynamic element) => 1,
      ),
      FREQ: freq.toString(),
      TIMING: timing.toString(),
      LOCATION: location.toString(),
      PRICE: price.toJson(),
      TUTOR_GENDER: Map<String, dynamic>.fromIterable(
        tutorGender,
        key: (dynamic element) => element.toShortString(),
        value: (dynamic element) => 1,
      ),
      TUTOR_OCCUPATIONS: Map<String, dynamic>.fromIterable(
        tutorOccupation,
        key: (dynamic element) => element.toShortString(),
        value: (dynamic elemetn) => 1,
      ),
    };
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      CLASS_FORMATS: classFormat.map((e) => e.toShortString()).toList(),
      FREQ: freq.toString(),
      TIMING: timing.toString(),
      LOCATION: location.toString(),
      PRICE: price.toJson(),
      TUTOR_GENDER: tutorGender.map((e) => e.toShortString()).toList(),
      TUTOR_OCCUPATIONS: tutorOccupation.map((e) => e.toShortString()).toList(),
    };
  }

  @override
  String toString() => '''RequirementsTuteeEntity(
      classFormat: $classFormat,
      freq: $freq,
      timing: $timing,
      loc: $location,
      price: $price,
      tutorGenders: $tutorGender,
      tutorOccupations: $tutorOccupation,
    }''';
}
