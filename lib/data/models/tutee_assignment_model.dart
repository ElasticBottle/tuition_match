import 'package:cotor/data/models/subject_model.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'map_key_strings.dart';
import 'name_model.dart';

class TuteeAssignmentModel extends TuteeAssignment {
  const TuteeAssignmentModel({
    String postId,
    @required String photoUrl,
    @required String uid,
    @required this.tuteeNameModel,
    @required Gender gender,
    @required Level level,
    @required this.subjectModel,
    @required ClassFormat format,
    @required TutorOccupation tutorOccupation,
    @required String timing,
    @required String location,
    @required String freq,
    @required double rateMin,
    @required double rateMax,
    @required String additionalRemarks,
    Status status,
    int numApplied,
    int numLiked,
    String dateAdded,
    @required bool isVerifiedAccount,
  }) : super(
          postId: postId,
          additionalRemarks: additionalRemarks,
          numApplied: numApplied,
          format: format,
          gender: gender,
          level: level,
          subject: subjectModel,
          timing: timing,
          rateMax: rateMax,
          rateMin: rateMin,
          location: location,
          freq: freq,
          tutorOccupation: tutorOccupation,
          status: status,
          uid: uid,
          tuteeName: tuteeNameModel,
          numLiked: numLiked,
          photoUrl: photoUrl,
          dateAdded: dateAdded,
          isVerifiedAccount: isVerifiedAccount,
        );

  factory TuteeAssignmentModel.fromJson(Map<String, dynamic> json) {
    return TuteeAssignmentModel(
      postId: json[POSTID],
      uid: json[UID],
      level: Level.values[json[LEVEL]],
      tutorOccupation: TutorOccupation.values[json[TUTOR_OCCUPATION]],
      format: ClassFormat.values[json[CLASSFORMAT]],
      gender: Gender.values[json[GENDER]],
      status: Status.values[json[STATUS]],
      subjectModel: SubjectModel.fromJson(json[SUBJECT]),
      additionalRemarks: json[ADDITIONAL_REMARKS],
      numApplied: json[NUM_APPLIED],
      freq: json[FREQ],
      numLiked: json[NUM_LIKED],
      location: json[LOCATION],
      timing: json[TIMING],
      tuteeNameModel: NameModel.fromJson(json[TUTEE_NAME]),
      rateMax: json[RATEMAX].toDouble(),
      rateMin: json[RATEMIN].toDouble(),
      photoUrl: json[PHOTOURL],
      dateAdded: json[DATE_ADDED].toString(),
      isVerifiedAccount: json[IS_VERIFIED_ACCOUNT],
    );

    // timeago.format(json[DATE_ADDED].toDate(), locale: 'en_short'));
  }

  factory TuteeAssignmentModel.fromDocumentSnapshot(
      {Map<String, dynamic> json, String postId}) {
    json.addAll(<String, String>{POSTID: postId});
    json[DATE_ADDED] = json[DATE_ADDED].toDate();
    return TuteeAssignmentModel.fromJson(json);
  }

  final SubjectModel subjectModel;
  final NameModel tuteeNameModel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      POSTID: postId,
      UID: uid,
      TUTEE_NAME: tuteeNameModel.toJson(),
      PHOTOURL: photoUrl,
      DATE_ADDED: dateAdded,
      LEVEL: level.index,
      SUBJECT: subjectModel.toJson(),
      TIMING: timing,
      LOCATION: location,
      RATEMIN: rateMin,
      RATEMAX: rateMax,
      GENDER: gender.index,
      FREQ: freq,
      TUTOR_OCCUPATION: tutorOccupation.index,
      CLASSFORMAT: format.index,
      ADDITIONAL_REMARKS: additionalRemarks,
      NUM_APPLIED: numApplied,
      NUM_LIKED: numLiked,
      STATUS: status.index,
      IS_VERIFIED_ACCOUNT: isVerifiedAccount,
    };
  }

  List<dynamic> toDocumentSnapshot() {
    final List<String> toExclude = [
      POSTID,
      DATE_ADDED,
      NUM_APPLIED,
      NUM_LIKED,
      STATUS,
    ];
    final Map<String, dynamic> toUpdate = toJson();
    toUpdate.removeWhere((key, dynamic value) => toExclude.contains(key));
    return <dynamic>[postId, toUpdate];
  }
}
