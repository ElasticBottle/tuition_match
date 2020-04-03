import 'package:cotor/domain/entities/subject.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
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
      level: Level.values[json[LEVEL]],
      sbjArea: json[SUBJECTAREA],
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      LEVEL: level.index,
      SUBJECTAREA: subjectArea,
    };
  }
}
