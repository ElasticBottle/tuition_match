import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/grade.dart';

const String bandShort = 'Bnd';
const String gradeStringShort = 'G';
const String passShort = 'P';
const String meritShort = 'M';
const String distinctionShort = 'D';

class GradeEntity extends Grade implements EntityBase<Grade> {
  const GradeEntity(String grade) : super(grade);

  factory GradeEntity.fromShortString(String grade) {
    if (grade == null || grade.isEmpty) {
      return null;
    }
    if (grade.length == 4) {
      return GradeEntity(band + ' ' + grade[3]);
    } else if (grade[0] == gradeStringShort) {
      return GradeEntity(gradeString + ' ' + grade[1]);
    } else if (grade == passShort) {
      return GradeEntity(pass);
    } else if (grade == meritShort) {
      return GradeEntity(merit);
    } else if (grade == distinctionShort) {
      return GradeEntity(distinction);
    }
    return GradeEntity(grade);
  }
  factory GradeEntity.fromDomainEntity(Grade entity) {
    if (entity == null) {
      return null;
    }
    return GradeEntity(entity.grade);
  }

  String toShortString() {
    if (grade.length >= 4) {
      if (grade.substring(0, 4) == band) {
        return bandShort + grade.substring(5);
      } else if (grade.substring(0, 4) == gradeString.substring(0, 4)) {
        return gradeStringShort + grade.substring(6);
      } else if (grade == pass) {
        return passShort;
      } else if (grade == merit) {
        return meritShort;
      } else if (grade == distinction) {
        return distinctionShort;
      }
    }
    return grade;
  }

  @override
  Grade toDomainEntity() {
    return Grade(grade);
  }
}
