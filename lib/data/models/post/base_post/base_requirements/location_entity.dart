import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_requirements/location.dart';

class LocationEntity extends Location implements EntityBase<Location> {
  const LocationEntity({String location}) : super(location: location);

  factory LocationEntity.fromString(String loc) {
    return LocationEntity(location: loc);
  }

  factory LocationEntity.fromDomainEntity(Location loc) {
    return LocationEntity(location: loc.loc);
  }

  @override
  Location toDomainEntity() {
    return Location(location: loc);
  }
}
