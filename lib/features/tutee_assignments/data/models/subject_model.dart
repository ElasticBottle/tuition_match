import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'map_key_strings.dart';

class SubjectModel extends Subject {
  const SubjectModel({
    Level level,
    String sbjArea,
  }) : super(
          level: level,
          subjectArea: sbjArea,
        );

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      level: Level.values[json[level]],
      sbjArea: json[subjectArea],
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      level: this.level.index,
      subjectArea: this.subjectArea,
    };
  }
}
