import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/class_format_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/location_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/price_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/timing_entity.dart';
import 'package:cotor/domain/entities/post/tutor_profile/requirements/requirements_tutor.dart';

class RequirementsTutorEntity extends RequirementsTutor
    implements EntityBase<RequirementsTutor> {
  const RequirementsTutorEntity({
    List<ClassFormatEntity> classFormat,
    PriceEntity price,
    TimingEntity timing,
    LocationEntity loc,
  })  : _classFormat = classFormat,
        _timing = timing,
        _loc = loc,
        _price = price;

  factory RequirementsTutorEntity.fromFirebaseMap(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return RequirementsTutorEntity(
      classFormat: json[CLASS_FORMATS]
          .entries
          .map<ClassFormatEntity>(
            (MapEntry<String, dynamic> e) =>
                ClassFormatEntity.fromString(e.key),
          )
          .toList(),
      timing: TimingEntity.fromString(json[TIMING]),
      loc: LocationEntity.fromString(json[LOCATION]),
      price: PriceEntity.fromJson(json[PRICE]),
    );
  }
  factory RequirementsTutorEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return RequirementsTutorEntity(
      classFormat: json[CLASS_FORMATS]
          .cast<String>()
          .map<ClassFormatEntity>(
            (String e) => ClassFormatEntity.fromString(e),
          )
          .toList(),
      timing: TimingEntity.fromString(json[TIMING]),
      loc: LocationEntity.fromString(json[LOCATION]),
      price: PriceEntity.fromJson(json[PRICE]),
    );
  }
  factory RequirementsTutorEntity.fromDomainEntity(RequirementsTutor entity) {
    return RequirementsTutorEntity(
      classFormat: entity.classFormat
          .map((e) => ClassFormatEntity.fromDomainEntity(e))
          .toList(),
      timing: TimingEntity.fromDomainEntity(entity.timing),
      loc: LocationEntity.fromDomainEntity(entity.location),
      price: PriceEntity.fromDomainEntity(entity.price),
    );
  }

  final List<ClassFormatEntity> _classFormat;
  final TimingEntity _timing;
  final LocationEntity _loc;
  final PriceEntity _price;

  @override
  List<ClassFormatEntity> get classFormat => _classFormat;

  @override
  LocationEntity get location => _loc;

  @override
  PriceEntity get price => _price;

  @override
  TimingEntity get timing => _timing;

  @override
  RequirementsTutor toDomainEntity() {
    return RequirementsTutor(
      classFormat: classFormat.map((e) => e.toDomainEntity()).toList(),
      timing: timing.toDomainEntity(),
      location: location.toDomainEntity(),
      price: price.toDomainEntity(),
    );
  }

  Map<String, dynamic> toFirebaseMap() {
    return <String, dynamic>{
      CLASS_FORMATS: Map.fromIterable(
        classFormat,
        key: (dynamic element) => element.toString(),
        value: (dynamic element) => 1,
      ),
      TIMING: timing.toString(),
      LOCATION: location.toString(),
      PRICE: price.toJson(),
    };
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      CLASS_FORMATS: classFormat.map((e) => e.toString()).toList(),
      TIMING: timing.toString(),
      LOCATION: location.toString(),
      PRICE: price.toJson(),
    };
  }

  @override
  List<Object> get props => [
        _classFormat,
        _loc,
        _price,
        _timing,
      ];

  @override
  String toString() {
    return '''RequirementsTutorEntity(
      classFormat: $classFormat, 
      timing: $timing, 
      loc: $location, 
      price: $price
    )''';
  }
}
