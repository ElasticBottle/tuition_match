import 'package:cotor/features/tutee_assignments/data/models/name_model.dart';
import 'package:cotor/features/tutee_assignments/data/models/subject_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';

import 'map_key_strings.dart';

class TuteeAssignmentModel extends TuteeAssignment {
  const TuteeAssignmentModel({
    String postId,
    Gender gender,
    Level level,
    this.subjectModel,
    ClassFormat format,
    String timing,
    double rateMin,
    double rateMax,
    String location,
    String freq,
    TutorOccupation tutorOccupation,
    String additionalRemarks,
    Status status,
    String username,
    this.tuteeNameModel,
    int applied,
    List<String> liked,
  }) : super(
            postId: postId,
            additionalRemarks: additionalRemarks,
            applied: applied,
            format: format,
            gender: gender,
            level: level,
            subject: subjectModel,
            timing: timing,
            rateMax: rateMax,
            rateMin: rateMin,
            location: location,
            freq: freq,
            tutorOccupation: tutorOccupation,
            status: status,
            username: username,
            tuteeName: tuteeNameModel,
            liked: liked);

  factory TuteeAssignmentModel.fromJson(Map<String, dynamic> json) {
    return TuteeAssignmentModel(
      postId: json.keys.first,
      username: json[POSTID][USERNAME],
      level: Level.values[json[POSTID][LEVEL]],
      tutorOccupation: TutorOccupation.values[json[POSTID][TUTOR_OCCUPATION]],
      format: ClassFormat.values[json[POSTID][CLASSFORMAT]],
      gender: Gender.values[json[POSTID][GENDER]],
      status: Status.values[json[POSTID][STATUS]],
      subjectModel: SubjectModel.fromJson(json[POSTID][SUBJECT]),
      additionalRemarks: json[POSTID][ADDITIONAL_REMARKS],
      applied: json[POSTID][APPLIED],
      freq: json[POSTID][FREQ],
      liked: json[POSTID][LIKED].cast<String>(),
      location: json[POSTID][LOCATION],
      timing: json[POSTID][TIMING],
      tuteeNameModel: NameModel.fromJson(json[POSTID][TUTEE_NAME]),
      rateMax: json[POSTID][RATEMAX],
      rateMin: json[POSTID][RATEMIN],
    );
  }

  final SubjectModel subjectModel;
  final NameModel tuteeNameModel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      postId: {
        LEVEL: level.index,
        SUBJECT: subjectModel.toJson(),
        TIMING: timing,
        LOCATION: location,
        RATEMIN: rateMin,
        RATEMAX: rateMax,
        GENDER: gender.index,
        FREQ: freq,
        TUTOR_OCCUPATION: tutorOccupation.index,
        CLASSFORMAT: format.index,
        ADDITIONAL_REMARKS: additionalRemarks,
        APPLIED: applied,
        LIKED: liked,
        STATUS: status.index,
        USERNAME: username,
        TUTEE_NAME: tuteeNameModel.toJson(),
      }
    };
  }
}
