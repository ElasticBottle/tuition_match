import 'package:cotor/domain/entities/enums.dart';
import 'package:equatable/equatable.dart';

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
  static const String H1CHEM = 'H1Chem';
  static const String H1BIO = 'H1Bio';
  static const String H1PHY = 'H1Phy';
  static const String H2CHEM = 'H2Chem';
  static const String H2BIO = 'H2Bio';
  static const String H2PHY = 'H2Phy';
}

class Math extends SubjectArea {
  const Math();
  static const String MATH = 'Math';
  static const String AMATH = 'AMath';
  static const String FMATH = 'FMath';
  static const String H1MATH = 'H1 Math';
  static const String H2MATH = 'H2 Math';
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
  static const String VIOLIN = 'Violin';
  static const String GUITAR = 'Guitar';
  static const String DRUMS = 'Drums';
}

class Languages extends SubjectArea {
  const Languages();
  static const String ENG = 'English';
  static const String CHI = 'Chinese';
  static const String MALAY = 'Malay';
  static const String TAMIL = 'Tamil';
  static const String HINDI = 'Hindi';
}
