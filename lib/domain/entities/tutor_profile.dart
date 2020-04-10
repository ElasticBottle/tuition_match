import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'package:equatable/equatable.dart';

import 'enums.dart';

class TutorProfile extends Equatable {
  const TutorProfile({
    this.postId,
    this.photoUrl,
    this.username,
    this.tuteeName,
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
    this.request,
    this.liked,
    this.rating,
  });
  final String postId;
  final String photoUrl;
  final Name tuteeName;
  final String username;
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
  final int request;
  final int liked;
  final double rating;

  TutorProfile copyWith({
    String postId,
    String photoUrl,
    Name tuteeName,
    String username,
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
    String sellingPoints,
    String location,
    Status status,
    int request,
    int liked,
    double rating,
  }) {
    return TutorProfile(
      postId: postId ?? this.postId,
      photoUrl: photoUrl ?? this.photoUrl,
      tuteeName: tuteeName ?? this.tuteeName,
      username: username ?? this.username,
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
      sellingPoints: sellingPoints ?? this.sellingPoints,
      location: location ?? this.location,
      status: status ?? this.status,
      request: request ?? this.request,
      liked: liked ?? this.liked,
      rating: rating ?? this.rating,
    );
  }

  @override
  List<Object> get props => [
        postId,
        photoUrl,
        tuteeName,
        username,
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
        sellingPoints,
        location,
        status,
        request,
        liked,
        rating,
      ];

  @override
  String toString() => '''TuteeAssignmet {
    postId : $postId ,
    photoUrl : $photoUrl ,
    tuteeName : $tuteeName ,
    username : $username ,
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
    sellingPoints : $sellingPoints ,
    location : $location ,
    status : $status ,
    request : $request ,
    liked : $liked ,
    rating : $rating ,
    ''';
}
