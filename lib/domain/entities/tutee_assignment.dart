import 'package:cotor/domain/entities/subject.dart';
import 'package:equatable/equatable.dart';

import 'name.dart';

enum Gender {
  male,
  female,
  other,
}

enum Level {
  K1,
  K2,
  pri1,
  pri2,
  pri3,
  pri4,
  pri5,
  pri6,
  pri,
  sec1,
  sec2,
  sec3,
  sec4,
  sec,
  jC1,
  jC2,
  jc,
  poly,
  uni,
  other,
  all,
}

String describeEnum(dynamic value) {
  final List<String> output = value.toString().split('.');
  return output[1];
}

enum ClassFormat {
  online,
  private,
  group,
}

enum TutorOccupation {
  partTime,
  fullTime,
  moe,
}

enum Status {
  open,
  close,
}

class TuteeAssignment extends Equatable {
  const TuteeAssignment({
    this.username,
    this.tuteeName,
    this.postId,
    this.gender,
    this.level,
    this.subject,
    this.format,
    this.timing,
    this.rateMax,
    this.rateMin,
    this.location,
    this.freq,
    this.tutorOccupation,
    this.additionalRemarks,
    this.status,
    this.applied,
    this.liked,
  });
  final String postId;
  final Gender gender;
  final Level level;
  final Subject subject;
  final ClassFormat format;
  final String timing;
  final double rateMin;
  final double rateMax;
  final String location;
  final String freq;
  final TutorOccupation tutorOccupation;
  final String additionalRemarks;
  final Status status;
  final String username;
  final Name tuteeName;
  final int applied;
  final int liked;

  @override
  List<Object> get props => [
        postId,
        gender,
        level,
        subject,
        format,
        timing,
        rateMax,
        rateMax,
        location,
        freq,
        tutorOccupation,
        additionalRemarks,
        status,
        applied,
        username,
        tuteeName,
        liked,
      ];
}
