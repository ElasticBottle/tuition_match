import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';
import 'package:equatable/equatable.dart';

abstract class SubjectArea extends Equatable {
  const SubjectArea();
  static List<SubjectArea> get pri {
    final List<SubjectArea> toReturn = [];
    toReturn.addAll(Science.pri);
    toReturn.addAll(Math.pri);
    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    return toReturn;
  }

  static List<SubjectArea> get sec {
    final List<SubjectArea> toReturn = [];
    toReturn.addAll(Science.sec);
    toReturn.addAll(Math.sec);
    toReturn.addAll(Humans.sec);
    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    return toReturn;
  }

  static List<SubjectArea> get jc {
    final List<SubjectArea> toReturn = [];
    toReturn.addAll(Science.jc);
    toReturn.addAll(Math.jc);
    toReturn.addAll(Humans.jc);
    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    return toReturn;
  }

  static List<SubjectArea> get ib {
    final List<SubjectArea> toReturn = [];
    toReturn.addAll(Science.ib);
    toReturn.addAll(Math.ib);
    toReturn.addAll(Humans.ib);
    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    return toReturn;
  }

  static List<SubjectArea> get poly {
    final List<SubjectArea> toReturn = [];
    toReturn.addAll(Music.instruments);

    return toReturn;
  }

  static List<SubjectArea> get uni {
    final List<SubjectArea> toReturn = [];
    toReturn.addAll(Music.instruments);

    return toReturn;
  }

  static List<SubjectArea> get other {
    final List<SubjectArea> toReturn = [];

    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    toReturn.addAll(Sports.all);
    return toReturn;
  }

  static List<SubjectArea> getSubjectsToDisplay(List<String> levels) {
    final Set<SubjectArea> toReturn = {};
    for (String level in levels) {
      if (Level.pri.contains(level)) {
        toReturn.addAll(pri);
      }
      if (Level.sec.contains(level)) {
        toReturn.addAll(sec);
      }
      if (Level.jc.contains(level)) {
        toReturn.addAll(jc);
      }
      if (Level.ib.contains(level)) {
        toReturn.addAll(ib);
      }
      if (Level.uni.contains(level)) {
        toReturn.addAll(uni);
      }
      if (Level.poly.contains(level)) {
        toReturn.addAll(poly);
      }
      if (level == Level.OTHER.toString()) {
        toReturn.addAll(other);
      }
    }
    return toReturn.toList();
  }

  static List<int> toIndices(List<String> value, List<String> levels) {
    final List<String> subjects =
        getSubjectsToDisplay(levels).map((e) => e.toString());
    return value.map((e) => subjects.indexOf(e)).toList();
  }

  static List<SubjectArea> fromIndices(List<int> value, List<String> level) {
    final List<SubjectArea> subjects = getSubjectsToDisplay(level);
    return value.map((e) => subjects[e]).toList();
  }
}

class Science extends SubjectArea {
  const Science._(this._science);

  final String _science;

  static const Science SCIENCE = Science._('Science');

  static const Science CHEM = Science._('Chemistry');
  static const Science BIO = Science._('Biology');
  static const Science PHY = Science._('Physics');

  static const Science H1CHEM = Science._('H1 Chemistry');
  static const Science H1BIO = Science._('H1 Biology');
  static const Science H1PHY = Science._('H1 Physics');

  static const Science H2CHEM = Science._('H2 Chemistry');
  static const Science H2BIO = Science._('H2 Biology');
  static const Science H2PHY = Science._('H2 Physics');

  static const Science H3CHEM = Science._('H3 Chemistry');
  static const Science H3BIO = Science._('H3 Biology');
  static const Science H3PHY = Science._('H3 Physics');

  static const Science SLCHEM = Science._('SL Chemistry');
  static const Science HLCHEM = Science._('HL Chemistry');
  static const Science SLBIO = Science._('SL Biology');
  static const Science HLBIO = Science._('HL Biology');
  static const Science SLPHY = Science._('SL Physics');
  static const Science HLPHY = Science._('HL Physics');

  static List<Science> get ib => const [
        SLCHEM,
        HLCHEM,
        SLBIO,
        HLBIO,
        SLPHY,
        HLPHY,
      ];
  static List<Science> get jc => const [
        H1CHEM,
        H1BIO,
        H1PHY,
        H2CHEM,
        H2BIO,
        H2PHY,
        H3CHEM,
        H3BIO,
        H3PHY,
      ];
  static List<Science> get sec => const [CHEM, BIO, PHY];
  static List<Science> get pri => const [SCIENCE];

  @override
  String toString() => _science;

  @override
  List<Object> get props => [_science];
}

class Math extends SubjectArea {
  const Math._(this._math);

  final String _math;
  static const Math MATH = Math._('Math');
  static const Math EMATH = Math._('EMath');
  static const Math AMATH = Math._('AMath');
  static const Math FMATH = Math._('FMath');
  static const Math H1MATH = Math._('H1 Math');
  static const Math H2MATH = Math._('H2 Math');
  static const Math H3MATH = Math._('H3 Math');
  static const Math SLMATH = Math._('SL Math');
  static const Math HLMATH = Math._('HL Math');

  static List<Math> get pri => const [MATH];
  static List<Math> get sec => const [AMATH, EMATH];
  static List<Math> get jc => const [H1MATH, H2MATH, H3MATH, FMATH];
  static List<Math> get ib => const [SLMATH, HLMATH];

  @override
  String toString() => _math;
  @override
  List<Object> get props => [_math];
}

class Humans extends SubjectArea {
  const Humans._(this._humans);
  final String _humans;
  static const Humans HIST = Humans._('Hist');
  static const Humans GEOG = Humans._('Geog');
  static const Humans LIT = Humans._('Lit');
  static const Humans POA = Humans._('POA');
  static const Humans SS = Humans._('SS');
  static const Humans ART = Humans._('Art');

  static const Humans GP = Humans._('Gp');

  static const Humans SLBM = Humans._('SL Business Management');
  static const Humans HLBM = Humans._('HL Business Management');
  static const Humans SLLANGLIT = Humans._('SL Language Literature');
  static const Humans HLLANGLIT = Humans._('HL Language Literature');
  static const Humans SLHIST = Humans._('SL Hist');
  static const Humans HLHIST = Humans._('HL Hist');
  static const Humans SLGEOG = Humans._('SL Geog');
  static const Humans HLGEOG = Humans._('HL Geog');
  static const Humans HLLIT = Humans._('HL Lit');
  static const Humans SLLIT = Humans._('SL Lit');

  static List<Humans> get sec => const [
        HIST,
        GEOG,
        LIT,
        POA,
        SS,
        ART,
      ];
  static List<Humans> get jc => const [
        HIST,
        GEOG,
        LIT,
        GP,
        ART,
      ];
  static List<Humans> get ib => const [
        SLBM,
        HLBM,
        SLLANGLIT,
        HLLANGLIT,
        SLHIST,
        HLHIST,
        SLGEOG,
        HLGEOG,
        HLLIT,
        SLLIT,
      ];

  @override
  String toString() => _humans;

  @override
  List<Object> get props => [_humans];
}

class Music extends SubjectArea {
  const Music._(this._music);

  final String _music;
  static const Music PIANO = Music._('Piano');
  static const Music VIOLIN = Music._('Violin');
  static const Music GUITAR = Music._('Guitar');
  static const Music DRUMS = Music._('Drums');

  static List<Music> get instruments => const [
        PIANO,
        VIOLIN,
        GUITAR,
        DRUMS,
      ];

  @override
  String toString() => _music;
  @override
  List<Object> get props => [_music];
}

class Sports extends SubjectArea {
  const Sports._(this._sport);
  final String _sport;
  static const Sports BADMINTON = Sports._('Badminton');

  static List<Sports> get all => const [
        BADMINTON,
      ];

  @override
  String toString() => _sport;
  @override
  List<Object> get props => [_sport];
}

class Languages extends SubjectArea {
  const Languages._(this._lang);
  final String _lang;
  static const Languages ENG = Languages._('English');
  static const Languages CHI = Languages._('Chinese');
  static const Languages MALAY = Languages._('Malay');
  static const Languages TAMIL = Languages._('Tamil');
  static const Languages HINDI = Languages._('Hindi');
  static const Languages KOREAN = Languages._('Korean');
  static const Languages JAPANESE = Languages._('Japanese');
  static const Languages SPANISH = Languages._('French');
  static const Languages FRENCH = Languages._('Spanish');

  static List<Languages> get languages => const [
        ENG,
        CHI,
        MALAY,
        TAMIL,
        HINDI,
        KOREAN,
        JAPANESE,
        SPANISH,
        FRENCH,
      ];

  @override
  String toString() => _lang;
  @override
  List<Object> get props => [_lang];
}
