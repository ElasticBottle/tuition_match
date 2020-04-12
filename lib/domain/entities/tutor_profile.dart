import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'package:equatable/equatable.dart';

import 'enums.dart';

class TutorProfile extends Equatable {
  const TutorProfile({
    this.photoUrl,
    this.uid,
    this.tutorName,
    this.dateAdded,
    this.dateModified,
    this.gender,
    this.tutorOccupation,
    this.levelsTaught,
    this.subjects,
    this.rateMax,
    this.rateMin,
    this.timing,
    this.formats,
    this.qualifications,
    this.sellingPoints,
    this.location,
    this.status,
    this.numClicks,
    this.numRequest,
    this.numLiked,
    this.rating,
    this.isVerifiedTutor,
  });
  final String photoUrl;
  final String uid;
  final Name tutorName;
  final String dateAdded;
  final String dateModified;
  final Gender gender;
  final TutorOccupation tutorOccupation;
  final List<Level> levelsTaught;
  final List<Subject> subjects;
  final double rateMin;
  final double rateMax;
  final String timing;
  final List<ClassFormat> formats;
  final String qualifications;
  final String sellingPoints;
  final String location;
  final Status status;
  final int numClicks;
  final int numRequest;
  final int numLiked;
  final double rating;
  final bool isVerifiedTutor;

  TutorProfile copyWith({
    String photoUrl,
    String uid,
    Name tutorName,
    String dateAdded,
    String dateModified,
    Gender gender,
    TutorOccupation tutorOccupation,
    List<Level> levelsTaught,
    List<Subject> subjects,
    double rateMin,
    double rateMax,
    String timing,
    List<ClassFormat> formats,
    String qualifications,
    String sellingPoints,
    String location,
    Status status,
    int numClicks,
    int numRequest,
    int numLiked,
    double rating,
    bool isVerifiedTutor,
  }) {
    return TutorProfile(
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      tutorName: tutorName ?? this.tutorName,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      gender: gender ?? this.gender,
      tutorOccupation: tutorOccupation ?? this.tutorOccupation,
      levelsTaught: levelsTaught ?? this.levelsTaught,
      subjects: subjects ?? this.subjects,
      rateMin: rateMin ?? this.rateMin,
      rateMax: rateMax ?? this.rateMax,
      timing: timing ?? this.timing,
      formats: formats ?? this.formats,
      qualifications: qualifications ?? this.qualifications,
      sellingPoints: sellingPoints ?? this.sellingPoints,
      location: location ?? this.location,
      status: status ?? this.status,
      numClicks: numClicks ?? this.numClicks,
      numRequest: numRequest ?? this.numRequest,
      numLiked: numLiked ?? this.numLiked,
      rating: rating ?? this.rating,
      isVerifiedTutor: isVerifiedTutor ?? this.isVerifiedTutor,
    );
  }

  @override
  List<Object> get props => [
        photoUrl,
        uid,
        tutorName,
        dateAdded,
        dateModified,
        gender,
        tutorOccupation,
        levelsTaught,
        subjects,
        rateMin,
        rateMax,
        timing,
        formats,
        qualifications,
        sellingPoints,
        location,
        status,
        numClicks,
        numRequest,
        numLiked,
        rating,
        isVerifiedTutor,
      ];

  @override
  String toString() => '''TuteeAssignmet {
    photoUrl : $photoUrl ,
    uid : $uid ,
    tutorName : $tutorName ,
    dateAdded : $dateAdded ,
    dateModified: $dateModified,
    gender : $gender ,
    tutorOccupation : $tutorOccupation ,
    levelsTaught : $levelsTaught ,
    subjects : $subjects ,
    rateMin : $rateMin ,
    rateMax : $rateMax ,
    timing : $timing ,
    format : $formats ,
    qualifications : $qualifications,
    sellingPoints : $sellingPoints ,
    location : $location ,
    status : $status ,
    numClicks: $numClicks,
    numRequest : $numRequest ,
    numLiked : $numLiked ,
    rating : $rating ,
    isVerifiedTutor: $isVerifiedTutor,
    ''';
}
