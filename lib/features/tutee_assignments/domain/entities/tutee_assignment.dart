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

enum Subject {
  priEnglish,
  priChinese,
  priMalay,
  priTamil,
  priHindi,
  priMath,
  priScience,
  priAll,
  secEnglish,
  secChinese,
  secMalay,
  secTamil,
  secHindi,
  secMath,
  secAMath,
  secChem,
  secBio,
  secPhy,
  secHist,
  secGeog,
  secLit,
  secPOA,
  secSS,
  secArt,
  secAll,
  jcMath,
  jcFMath,
  jcChem,
  jcBio,
  jcPhy,
  jcHist,
  jcGeog,
  jcLit,
  jcGp,
  jcArt,
  jcAll,
  all,
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
    this.addtionalRemarks,
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
  final String addtionalRemarks;
  final Status status;
  final String username;
  final Name tuteeName;
  final int applied;
  final List<String> liked;

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
        addtionalRemarks,
        status,
        applied,
        username,
        tuteeName,
        liked,
      ];
}
