import 'package:cotor/features/tutee_assignments/domain/entities/name.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';

const String username = 'username';
const String level = 'level';
const String tutorOccupation = 'tutorOccupation';
const String classFormat = 'format';
const String gender = 'gender';
const String status = 'status';
const String freq = 'freq';
const String additionalRemarks = 'additionalRemarks';
const String applied = 'applied';
const String subject = 'subject';
const String tuteeName = 'tuteeName';
const String rateMax = 'rateMax';
const String rateMin = 'rateMin';
const String location = 'location';
const String liked = 'liked';
const String timing = 'timing';
const String postId = 'postId';

const String subjectArea = 'subjectArea';

const String firstName = 'firstName';
const String lastName = 'lastName';

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
      username: json[postId][username],
      level: Level.values[json[postId][level]],
      tutorOccupation: TutorOccupation.values[json[postId][tutorOccupation]],
      format: ClassFormat.values[json[postId][classFormat]],
      gender: Gender.values[json[postId][gender]],
      status: Status.values[json[postId][status]],
      subjectModel: SubjectModel.fromJson(json[postId][subject]),
      additionalRemarks: json[postId][additionalRemarks],
      applied: json[postId][applied],
      freq: json[postId][freq],
      liked: json[postId][liked].cast<String>(),
      location: json[postId][location],
      timing: json[postId][timing],
      tuteeNameModel: NameModel.fromJson(json[postId][tuteeName]),
      rateMax: json[postId][rateMax],
      rateMin: json[postId][rateMin],
    );
  }

  final SubjectModel subjectModel;
  final NameModel tuteeNameModel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      this.postId: {
        level: this.level.index,
        subject: subjectModel.toJson(),
        timing: this.timing,
        location: this.location,
        rateMin: this.rateMin,
        rateMax: this.rateMax,
        gender: this.gender.index,
        freq: this.freq,
        tutorOccupation: this.tutorOccupation.index,
        classFormat: format.index,
        additionalRemarks: this.additionalRemarks,
        applied: this.applied,
        liked: this.liked,
        status: this.status.index,
        username: this.username,
        tuteeName: tuteeNameModel.toJson(),
      }
    };
  }
}

class NameModel extends Name {
  const NameModel({
    String firstName,
    String lastName,
  }) : super(
          firstName: firstName,
          lastName: lastName,
        );

  factory NameModel.fromJson(Map json) {
    return NameModel(
      firstName: json[firstName],
      lastName: json[lastName],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      firstName: this.firstName,
      lastName: this.lastName,
    };
  }
}

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
