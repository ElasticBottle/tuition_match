import 'package:cotor/features/tutee_assignments/domain/entities/name.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';

class TuteeAssignmentModel extends TuteeAssignment {
  const TuteeAssignmentModel({
    Gender gender,
    Level level,
    Subject subject,
    ClassFormat format,
    String timing,
    double rateMin,
    double rateMax,
    String location,
    String freq,
    TutorOccupation tutorOccupation,
    String addtionalRemarks,
    Status status,
    String username,
    Name tuteeName,
    int applied,
    List<String> liked,
  }) : super(
            addtionalRemarks: addtionalRemarks,
            applied: applied,
            format: format,
            gender: gender,
            level: level,
            subject: subject,
            timing: timing,
            rateMax: rateMax,
            rateMin: rateMin,
            location: location,
            freq: freq,
            tutorOccupation: tutorOccupation,
            status: status,
            username: username,
            tuteeName: tuteeName,
            liked: liked);

  factory TuteeAssignmentModel.fromJson(Map<String, dynamic> json) {
    // TODO(ElasticBottle): do up implementation
    throw UnimplementedError;
  }

  Map<String, dynamic> toJson() {
    // TODO(ElasticBottle): do up implementation

    throw UnimplementedError;
  }
}
