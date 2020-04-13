import 'package:cotor/data/models/subject_model.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';

import 'map_key_strings.dart';
import 'name_model.dart';

class TutorProfileModel extends TutorProfile {
  const TutorProfileModel({
    String photoUrl,
    String uid,
    this.tutorNameModel,
    String dateAdded,
    String dateModified,
    Gender gender,
    TutorOccupation tutorOccupation,
    List<Level> levelsTaught,
    this.subjectModelList,
    double rateMin,
    double rateMax,
    String timing,
    List<ClassFormat> formats,
    String qualifications,
    String sellingPoints,
    String location,
    Status status,
    int numClicks,
    int numRequest,
    int numLiked,
    double rating,
    bool isVerifiedTutor,
  }) : super(
          photoUrl: photoUrl,
          uid: uid,
          tutorName: tutorNameModel,
          dateAdded: dateAdded,
          dateModified: dateModified,
          gender: gender,
          tutorOccupation: tutorOccupation,
          levelsTaught: levelsTaught,
          subjects: subjectModelList,
          rateMax: rateMax,
          rateMin: rateMin,
          timing: timing,
          formats: formats,
          qualifications: qualifications,
          sellingPoints: sellingPoints,
          location: location,
          status: status,
          numClicks: numClicks,
          numRequest: numRequest,
          numLiked: numLiked,
          rating: rating,
          isVerifiedTutor: isVerifiedTutor,
        );

  factory TutorProfileModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return TutorProfileModel();
    }
    return TutorProfileModel(
        photoUrl: json[PHOTOURL],
        uid: json[UID],
        tutorNameModel: NameModel.fromJson(json[TUTOR_NAME]),
        dateAdded: json[DATE_ADDED].toString(),
        dateModified: json[DATE_MODIFIED].toString(),
        gender: Gender.values[json[GENDER]],
        tutorOccupation: TutorOccupation.values[json[TUTOR_OCCUPATION]],
        levelsTaught:
            json[LEVELS_TAUGHT].map((int e) => Level.values[e]).toList(),
        subjectModelList: json[SUBJECTS]
            .map((Map<String, dynamic> e) => SubjectModel.fromJson(e))
            .toList(),
        rateMax: json[RATEMAX].toDouble(),
        rateMin: json[RATEMIN].toDouble(),
        timing: json[TIMING],
        formats:
            json[CLASS_FORMATS].map((int e) => ClassFormat.values[e]).toList(),
        qualifications: json[QUALIFICATIONS],
        sellingPoints: json[SELLING_POINTS],
        location: json[LOCATION],
        status: Status.values[json[STATUS]],
        numClicks: json[NUM_CLICKS],
        numRequest: json[NUM_REQUEST],
        numLiked: json[NUM_LIKED],
        rating: json[RATING],
        isVerifiedTutor: json[IS_VERIFIED_TUTOR]);

    // timeago.format(json[DATE_ADDED].toDate(), locale: 'en_short'));
  }

  factory TutorProfileModel.fromDocumentSnapshot(
      {Map<String, dynamic> json, String postId}) {
    json.addAll(<String, String>{UID: postId});
    json[DATE_ADDED] = json[DATE_ADDED].toDate();
    json[DATE_MODIFIED] = json[DATE_MODIFIED].toDate();
    return TutorProfileModel.fromJson(json);
  }

  final List<SubjectModel> subjectModelList;
  final NameModel tutorNameModel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      PHOTOURL: photoUrl,
      UID: uid,
      TUTOR_NAME: tutorNameModel.toJson(),
      DATE_ADDED: dateAdded,
      DATE_MODIFIED: dateModified,
      GENDER: gender.index,
      TUTOR_OCCUPATION: tutorOccupation.index,
      LEVELS_TAUGHT: levelsTaught.map((e) => e.index).toList(),
      SUBJECTS: subjectModelList.map((e) => e.toJson()).toList(),
      RATEMIN: rateMin,
      RATEMAX: rateMax,
      TIMING: timing,
      CLASS_FORMATS: formats.map((e) => e.index).toList(),
      QUALIFICATIONS: qualifications,
      SELLING_POINTS: sellingPoints,
      LOCATION: location,
      STATUS: status.index,
      IS_VERIFIED_TUTOR: isVerifiedTutor,
      NUM_CLICKS: numClicks,
      NUM_REQUEST: numRequest,
      NUM_LIKED: numLiked,
      RATING: rating,
    };
  }

  List<dynamic> toDocumentSnapshot() {
    final List<String> toExclude = [
      UID,
      DATE_ADDED,
      DATE_MODIFIED,
      NUM_CLICKS,
      NUM_REQUEST,
      NUM_LIKED,
      RATING,
      STATUS,
    ];

    final Map<String, dynamic> toUpdate = toJson();
    toUpdate.removeWhere((key, dynamic value) => toExclude.contains(key));
    return <dynamic>[uid, toUpdate];
  }
}
