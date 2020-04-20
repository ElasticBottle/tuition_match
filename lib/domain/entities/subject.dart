import 'package:cotor/domain/entities/level.dart';
import 'package:equatable/equatable.dart';

class Subject extends Equatable {
  const Subject();
  static List<String> get pri {
    final List<String> toReturn = [];
    toReturn.addAll(Science.pri);
    toReturn.addAll(Math.pri);
    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    return toReturn;
  }

  static List<String> get sec {
    final List<String> toReturn = [];
    toReturn.addAll(Science.sec);
    toReturn.addAll(Math.sec);
    toReturn.addAll(Humans.sec);
    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    return toReturn;
  }

  static List<String> get jc {
    final List<String> toReturn = [];
    toReturn.addAll(Science.jc);
    toReturn.addAll(Math.jc);
    toReturn.addAll(Humans.jc);
    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    return toReturn;
  }

  static List<String> get ib {
    final List<String> toReturn = [];
    toReturn.addAll(Science.ib);
    toReturn.addAll(Math.ib);
    toReturn.addAll(Humans.ib);
    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    return toReturn;
  }

  static List<String> get poly {
    final List<String> toReturn = [];
    toReturn.addAll(Music.instruments);

    return toReturn;
  }

  static List<String> get uni {
    final List<String> toReturn = [];
    toReturn.addAll(Music.instruments);

    return toReturn;
  }

  static List<String> get other {
    final List<String> toReturn = [];

    toReturn.addAll(Languages.languages);
    toReturn.addAll(Music.instruments);
    toReturn.addAll(Sports.all);
    return toReturn;
  }

  static List<String> getSubjectsToDisplay(List<String> levels) {
    final List<String> toReturn = [];
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
      if (level == Level.OTHER) {
        toReturn.addAll(other);
      }
    }
    return toReturn;
  }

  static List<int> toIndices(List<String> value, List<String> levels) {
    final List<String> subjects = getSubjectsToDisplay(levels);
    return value.map((e) => subjects.indexOf(e)).toList();
  }

  static List<String> fromIndices(List<int> value, List<String> level) {
    final List<String> subjects = getSubjectsToDisplay(level);
    return value.map((e) => subjects[e]).toList();
  }

  @override
  List<Object> get props => [];
}

abstract class SubjectArea extends Equatable {
  const SubjectArea();

  @override
  List<Object> get props => [];
}

class Science extends SubjectArea {
  const Science();

  static const String SCIENCE = 'Science';

  static const String CHEM = 'Chemistry';
  static const String BIO = 'Biology';
  static const String PHY = 'Physics';

  static const String H1CHEM = 'H1 Chemistry';
  static const String H1BIO = 'H1 Biology';
  static const String H1PHY = 'H1 Physics';

  static const String H2CHEM = 'H2 Chemistry';
  static const String H2BIO = 'H2 Biology';
  static const String H2PHY = 'H2 Physics';

  static const String H3CHEM = 'H3 Chemistry';
  static const String H3BIO = 'H3 Biology';
  static const String H3PHY = 'H3 Physics';

  static const String SLCHEM = 'SL Chemistry';
  static const String HLCHEM = 'HL Chemistry';
  static const String SLBIO = 'SL Biology';
  static const String HLBIO = 'HL Biology';
  static const String SLPHY = 'SL Physics';
  static const String HLPHY = 'HL Physics';

  static List<String> get ib => const [
        SLCHEM,
        HLCHEM,
        SLBIO,
        HLBIO,
        SLPHY,
        HLPHY,
      ];
  static List<String> get jc => const [
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
  static List<String> get sec => const [CHEM, BIO, PHY];
  static List<String> get pri => const [SCIENCE];
}

class Math extends SubjectArea {
  const Math();
  static const String MATH = 'Math';
  static const String EMATH = 'EMath';
  static const String AMATH = 'AMath';
  static const String FMATH = 'FMath';
  static const String H1MATH = 'H1 Math';
  static const String H2MATH = 'H2 Math';
  static const String H3MATH = 'H3 Math';
  static const String SLMATH = 'SL Math';
  static const String HLMATH = 'HL Math';

  static List<String> get pri => const [MATH];
  static List<String> get sec => const [AMATH, EMATH];
  static List<String> get jc => const [H1MATH, H2MATH, H3MATH, FMATH];
  static List<String> get ib => const [SLMATH, HLMATH];
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

  static const String SLBM = 'SL Business Management';
  static const String HLBM = 'HL Business Management';
  static const String SLLANGLIT = 'SL Language Literature';
  static const String HLLANGLIT = 'HL Language Literature';
  static const String SLHIST = 'SL Hist';
  static const String HLHIST = 'HL Hist';
  static const String SLGEOG = 'SL Geog';
  static const String HLGEOG = 'HL Geog';
  static const String HLLIT = 'HL Lit';
  static const String SLLIT = 'SL Lit';

  static List<String> get sec => const [
        HIST,
        GEOG,
        LIT,
        POA,
        SS,
        ART,
      ];
  static List<String> get jc => const [
        HIST,
        GEOG,
        LIT,
        GP,
        ART,
      ];
  static List<String> get ib => const [
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
}

class Music extends SubjectArea {
  const Music();
  static const String PIANO = 'Piano';
  static const String VIOLIN = 'Violin';
  static const String GUITAR = 'Guitar';
  static const String DRUMS = 'Drums';

  static List<String> get instruments => const [
        PIANO,
        VIOLIN,
        GUITAR,
        DRUMS,
      ];
}

class Sports extends SubjectArea {
  const Sports();
  static const String BADMINTON = 'Badminton';

  static List<String> get all => const [
        BADMINTON,
      ];
}

class Languages extends SubjectArea {
  const Languages();
  static const String ENG = 'English';
  static const String CHI = 'Chinese';
  static const String MALAY = 'Malay';
  static const String TAMIL = 'Tamil';
  static const String HINDI = 'Hindi';
  static const String KOREAN = 'Korean';
  static const String JAPANESE = 'Japanese';
  static const String SPANISH = 'French';
  static const String FRENCH = 'Spanish';

  static List<String> get languages => const [
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
}
