import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'package:equatable/equatable.dart';

import 'name.dart';

class TuteeAssignment extends Equatable {
  const TuteeAssignment({
    this.postId,
    this.photoUrl,
    this.uid,
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
    this.numApplied,
    this.numLiked,
    this.dateAdded,
    this.isVerifiedAccount,
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
  final String uid;
  final Name tuteeName;
  final int numApplied;
  final int numLiked;
  final String photoUrl;
  final String dateAdded;
  final bool isVerifiedAccount;

  TuteeAssignment copyWith({
    String postId,
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
    String additionalRemarks,
    Status status,
    String uid,
    Name tuteeName,
    int numApplied,
    int numLiked,
    String photoUrl,
    String dateAdded,
    bool isVerifiedAccount,
  }) {
    return TuteeAssignment(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      tuteeName: tuteeName ?? this.tuteeName,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      subject: subject ?? this.subject,
      format: format ?? this.format,
      tutorOccupation: tutorOccupation ?? this.tutorOccupation,
      timing: timing ?? this.timing,
      freq: freq ?? this.freq,
      location: location ?? this.location,
      rateMax: rateMax ?? this.rateMax,
      rateMin: rateMin ?? this.rateMin,
      additionalRemarks: additionalRemarks ?? this.additionalRemarks,
      status: status ?? this.status,
      numApplied: numApplied ?? this.numApplied,
      numLiked: numLiked ?? this.numLiked,
      photoUrl: photoUrl ?? this.photoUrl,
      dateAdded: dateAdded ?? this.dateAdded,
      isVerifiedAccount: isVerifiedAccount ?? this.isVerifiedAccount,
    );
  }

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
        numApplied,
        uid,
        tuteeName,
        numLiked,
        photoUrl,
        dateAdded,
        isVerifiedAccount,
      ];

  @override
  String toString() => '''TuteeAssignmet {
    postId : $postId ,
    gender : $gender ,
    level : $level ,
    subject : $subject ,
    format : $format ,
    timing : $timing ,
    rateMax : $rateMax ,
    rateMax : $rateMax ,
    location : $location ,
    freq : $freq ,
    tutorOccupation : $tutorOccupation ,
    additionalRemarks : $additionalRemarks ,
    status : $status ,
    numApplied : $numApplied ,
    uid : $uid ,
    tuteeName : $tuteeName ,
    numLiked : $numLiked ,
    photoUrl : $photoUrl ,
    dateAdded : $dateAdded ,
    isVerifiedAccount: $isVerifiedAccount, 
    ''';
}
