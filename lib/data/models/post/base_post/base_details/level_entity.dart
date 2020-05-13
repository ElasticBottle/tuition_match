import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';

class LevelEntity extends Level implements EntityBase<Level> {
  const LevelEntity(String level) : super(level);

  factory LevelEntity.fromShortString(String level) {
    if (level.substring(0, 3) ==
        Level.PRESCHOOL.toShortString().substring(0, 3)) {
      return LevelEntity.fromDomainEntity(Level.PRESCHOOL);
    } else if (level.substring(0, 3) ==
        Level.PRI1.toShortString().substring(0, 3)) {
      switch (level.substring(3)) {
        case '1':
          return LevelEntity.fromDomainEntity(Level.PRI1);
        case '2':
          return LevelEntity.fromDomainEntity(Level.PRI2);
        case '3':
          return LevelEntity.fromDomainEntity(Level.PRI3);
        case '4':
          return LevelEntity.fromDomainEntity(Level.PRI4);
        case '5':
          return LevelEntity.fromDomainEntity(Level.PRI5);
        case '6':
          return LevelEntity.fromDomainEntity(Level.PRI6);
      }
    } else if (level.substring(0, 3) ==
        Level.SEC1.toShortString().substring(0, 3)) {
      switch (level.substring(3)) {
        case '1':
          return LevelEntity.fromDomainEntity(Level.SEC1);
        case '2':
          return LevelEntity.fromDomainEntity(Level.SEC2);
        case '3':
          return LevelEntity.fromDomainEntity(Level.SEC3);
        case '4':
          return LevelEntity.fromDomainEntity(Level.SEC4);
        case '5':
          return LevelEntity.fromDomainEntity(Level.SEC5);
      }
    } else if (level.substring(0, 3) ==
        Level.POLY.toShortString().substring(0, 3)) {
      return LevelEntity.fromDomainEntity(Level.POLY);
    } else if (level.substring(0, 3) ==
        Level.UNI.toShortString().substring(0, 3)) {
      return LevelEntity.fromDomainEntity(Level.UNI);
    }
    return LevelEntity(level);
  }
  factory LevelEntity.fromDomainEntity(Level level) {
    return LevelEntity(level.level);
  }

  @override
  Level toDomainEntity() {
    return Level(level);
  }
}
