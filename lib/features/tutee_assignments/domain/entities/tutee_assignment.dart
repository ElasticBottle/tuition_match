import 'package:equatable/equatable.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/name.dart';

enum Gender {
  male,
  female,
  other,
}

enum Level {
  kindergarden1,
  kindergarden2,
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
  poly1,
  poly2,
  poly3,
  poly,
  uni,
  other,
  all,
}

class Subject extends Equatable {
  const Subject({this.level, this.subjectArea});

  final Level level;
  final String subjectArea;

  @override
  List<Object> get props => [
        level,
        subjectArea,
      ];

  @override
  String toString() => subjectArea;
}

String describeEnum(dynamic value) {
  final List<String> output = value.toString().split('.');
  return output[1];
}

class SubjectArea extends Equatable {
  const SubjectArea();
  static const String ANY = 'Any';

  @override
  List<Object> get props => [];
}

class Science extends SubjectArea {
  const Science();
  static const String SCIENCE = 'Science';
  static const String CHEM = 'Chem';
  static const String BIO = 'Bio';
  static const String PHY = 'Phy';
}

class Math extends SubjectArea {
  const Math();
  static const String MATH = 'Math';
  static const String AMATH = 'AMath';
  static const String FMATH = 'FMath';
}

class Humans extends SubjectArea {
  const Humans();
  static const String HIST = 'Hist';
  static const String GEOG = 'Geog';
  static const String LIT = 'Lit';
  static const String POA = 'POA';
  static const String SS = 'SS';
  static const String ART = 'Art';
  static const String GP = 'Gp';
}

class Music extends SubjectArea {
  const Music();
  static const String PIANO = 'Piano';
}

class Languages extends SubjectArea {
  const Languages();
  static const String ENG = 'English';
  static const String CHI = 'Chinese';
  static const String MALAY = 'Malay';
  static const String TAMIL = 'Tamil';
  static const String HINDI = 'Hindi';
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
