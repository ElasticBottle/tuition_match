import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'package:equatable/equatable.dart';

import 'name.dart';

class TuteeAssignment extends Equatable {
  const TuteeAssignment({
    this.postId,
    this.username,
    this.tuteeName,
    this.gender,
    this.level,
    this.subject,
    this.format,
    this.tutorOccupation,
    this.timing,
    this.freq,
    this.location,
    this.rateMax,
    this.rateMin,
    this.additionalRemarks,
    this.status,
    this.applied,
    this.liked,
    this.photoUrl,
    this.dateAdded,
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
  final String photoUrl;
  final String dateAdded;

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
