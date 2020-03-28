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

class Subject {
  Subject({this.level, this.subjectArea});

  Level level;
  String subjectArea;
}

class Science {
  final String _science = 'Science';
  final String _chem = 'Chem';
  final String _bio = 'Bio';
  final String _phy = 'Phy';

  String get science => _science;
  String get bio => _bio;
  String get chem => _chem;
  String get phy => _phy;
}

class Math {
  final String _math = 'Math';
  final String _aMath = 'AMath';
  final String _fMath = 'FMath';

  String get math => _math;
  String get aMath => _aMath;
  String get fMath => _fMath;
}

class Humans {
  final String _hist = 'Hist';
  final String _geog = 'Geog';
  final String _lit = 'Lit';
  final String _poa = 'POA';
  final String _ss = 'SS';
  final String _art = 'Art';
  final String _gp = 'Gp';

  String get hist => _hist;
  String get geog => _geog;
  String get lit => _lit;
  String get poa => _poa;
  String get ss => _ss;
  String get art => _art;
  String get gp => _gp;
}

class Music {
  final String _piano = 'Piano';

  String get paino => _piano;
}

class Languages {
  final String _eng = 'English';
  final String _chi = 'Chinese';
  final String _malay = 'Malay';
  final String _tamil = 'Tamil';
  final String _hindi = 'Hindi';

  String get eng => _eng;
  String get chi => _chi;
  String get malay => _malay;
  String get tamil => _tamil;
  String get hindi => _hindi;
}

class SubjectArea {
  Science _science;
  Math _math;
  Humans _humans;
  Languages _languages;
  Music _music;

  Science get science => _science;
  Math get math => _math;
  Humans get humans => _humans;
  Languages get languages => _languages;
  Music get music => _music;
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
