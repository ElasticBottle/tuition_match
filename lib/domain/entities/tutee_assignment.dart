import 'name.dart';

abstract class TuteeAssignment {
  String get postId;
  String get photoUrl;
  String get uid;
  Name get tuteeName;
  List<String> get tutorGender;
  List<String> get levels;
  List<String> get subjects;
  List<String> get formats;
  List<String> get tutorOccupation;
  String get timing;
  String get location;
  String get freq;
  double get proposedRate;
  double get rateMin;
  double get rateMax;
  String get rateType;
  String get additionalRemarks;
  bool get isOpen;
  bool get isPublic;
  int get numApplied;
  int get numLiked;
  String get dateAdded;
  bool get isVerifiedAccount;
}
