import 'package:cotor/data/models/subject_model.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';

import 'map_key_strings.dart';
import 'name_model.dart';

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
    int liked,
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
      postId: json[POSTID],
      username: json[USERNAME],
      level: Level.values[json[LEVEL]],
      tutorOccupation: TutorOccupation.values[json[TUTOR_OCCUPATION]],
      format: ClassFormat.values[json[CLASSFORMAT]],
      gender: Gender.values[json[GENDER]],
      status: Status.values[json[STATUS]],
      subjectModel: SubjectModel.fromJson(json[SUBJECT]),
      additionalRemarks: json[ADDITIONAL_REMARKS],
      applied: json[APPLIED],
      freq: json[FREQ],
      liked: json[LIKED],
      location: json[LOCATION],
      timing: json[TIMING],
      tuteeNameModel: NameModel.fromJson(json[TUTEE_NAME]),
      rateMax: json[RATEMAX].toDouble(),
      rateMin: json[RATEMIN].toDouble(),
    );
  }

  factory TuteeAssignmentModel.fromDocumentSnapshot(
      {Map<String, dynamic> json, String postId}) {
    json.addAll(<String, String>{POSTID: postId});
    return TuteeAssignmentModel.fromJson(json);
  }

  final SubjectModel subjectModel;
  final NameModel tuteeNameModel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      POSTID: postId,
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
    };
  }
}
