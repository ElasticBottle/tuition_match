import 'package:cotor/domain/entities/name.dart';
import 'package:equatable/equatable.dart';

abstract class TutorProfile extends Equatable {
  String get photoUrl;
  String get uid;
  Name get tutorName;
  String get dateAdded;
  String get dateModified;
  String get gender;
  String get tutorOccupation;
  List<String> get levelsTaught;
  List<String> get subjects;
  double get proposedRate;
  double get rateMin;
  double get rateMax;
  String get rateType;
  String get timing;
  List<String> get formats;
  String get qualifications;
  String get sellingPoints;
  String get location;
  bool get isPublic;
  int get numClicks;
  int get numRequest;
  int get numLiked;
  double get rating;
  bool get isVerifiedTutor;
}
