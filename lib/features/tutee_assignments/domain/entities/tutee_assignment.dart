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
  sec1,
  sec2,
  sec3,
  sec4,
  jC1,
  jC2,
  poly1,
  poly2,
  poly3,
  uni,
  other,
}

enum Subject {
  priEnglish,
  priChinese,
  priMalay,
  priTamil,
  priHindi,
  priMath,
  priScience,
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
  jcMath,
  jcFMath,
  jcChem,
  jcBio,
  jcPhy,
  jcHist,
  jcGeog,
  jcLit,
  jcGp,
  jcArt
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
  const TuteeAssignment(this.username, this.name,
      {this.postId,
      this.gender,
      this.level,
      this.subject,
      this.format,
      this.timing,
      this.ratePerStudent,
      this.location,
      this.freq,
      this.occupation,
      this.addtionalRemarks,
      this.status});
  final String postId;
  final Gender gender;
  final Level level;
  final Subject subject;
  final ClassFormat format;
  final String timing;
  final double ratePerStudent;
  final String location;
  final String freq;
  final TutorOccupation occupation;
  final String addtionalRemarks;
  final Status status;
  final String username;
  final Name name;

  @override
  List<Object> get props => [
        postId,
        gender,
        level,
        subject,
        format,
        timing,
        ratePerStudent,
        location,
        freq,
        occupation,
        addtionalRemarks,
        status
      ];
}
