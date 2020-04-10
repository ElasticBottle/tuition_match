import 'package:cotor/data/models/subject_model.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';

import 'map_key_strings.dart';
import 'name_model.dart';

class TutorProfileModel extends TutorProfile {
  const TutorProfileModel({
    String postId,
    String photoUrl,
    String username,
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
    int request,
    int liked,
    double rating,
  }) : super(
          postId: postId,
          photoUrl: photoUrl,
          username: username,
          tuteeName: tutorNameModel,
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
          request: request,
          liked: liked,
          rating: rating,
        );

  factory TutorProfileModel.fromJson(Map<String, dynamic> json) {
    return TutorProfileModel(
      postId: json[POSTID],
      photoUrl: json[PHOTOURL],
      username: json[USERNAME],
      tutorNameModel: NameModel.fromJson(json[TUTEE_NAME]),
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
      request: json[REQUEST],
      liked: json[LIKED],
      rating: json[RATING],
    );

    // timeago.format(json[DATE_ADDED].toDate(), locale: 'en_short'));
  }

  factory TutorProfileModel.fromDocumentSnapshot(
      {Map<String, dynamic> json, String postId}) {
    json.addAll(<String, String>{POSTID: postId});
    json[DATE_ADDED] = json[DATE_ADDED].toDate();
    json[DATE_MODIFIED] = json[DATE_MODIFIED].toDate();
    return TutorProfileModel.fromJson(json);
  }

  final List<SubjectModel> subjectModelList;
  final NameModel tutorNameModel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      POSTID: postId,
      PHOTOURL: photoUrl,
      USERNAME: username,
      TUTEE_NAME: tutorNameModel.toJson(),
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
      REQUEST: request,
      LIKED: liked,
      RATING: rating,
    };
  }

  List<dynamic> toDocumentSnapshot() {
    return <dynamic>[postId, toJson().remove(POSTID)];
  }
}
