import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/name_model.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:equatable/equatable.dart';

class TutorProfileEntity extends Equatable implements TutorProfile {
  const TutorProfileEntity({
    String photoUrl,
    String uid,
    Name tutorNameModel,
    String dateAdded,
    String dateModified,
    String gender,
    String tutorOccupation,
    List<String> levelsTaught,
    List<String> subjects,
    double proposedRate,
    double rateMin,
    double rateMax,
    String rateType,
    String timing,
    List<String> formats,
    String qualifications,
    String sellingPoints,
    String location,
    bool isPublic,
    int numClicks,
    int numRequest,
    int numLiked,
    double rating,
    bool isVerifiedTutor,
  })  : _tutorNameModel = tutorNameModel,
        _photoUrl = photoUrl,
        _uid = uid,
        _dateAdded = dateAdded,
        _dateModified = dateModified,
        _gender = gender,
        _tutorOccupation = tutorOccupation,
        _levelsTaught = levelsTaught,
        _subjects = subjects,
        _proposedRate = proposedRate,
        _rateMin = rateMin,
        _rateMax = rateMax,
        _timing = timing,
        _rateType = rateType,
        _formats = formats,
        _qualifications = qualifications,
        _sellingPoints = sellingPoints,
        _location = location,
        _isPublic = isPublic,
        _numClicks = numClicks,
        _numRequest = numRequest,
        _numLiked = numLiked,
        _rating = rating,
        _isVerifiedTutor = isVerifiedTutor;

  factory TutorProfileEntity.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return TutorProfileEntity();
    }
    return TutorProfileEntity(
        photoUrl: json[PHOTOURL],
        uid: json[UID],
        tutorNameModel: NameEntity.fromJson(json[TUTOR_NAME]),
        dateAdded: json[DATE_ADDED].toString(),
        dateModified: json[DATE_MODIFIED].toString(),
        gender: json[GENDER],
        tutorOccupation: json[TUTOR_OCCUPATION],
        levelsTaught: json[LEVELS_TAUGHT],
        subjects: json[SUBJECTS],
        proposedRate: double.parse(json[PROPOSED_RATE]),
        rateMax: double.parse(json[RATEMAX]),
        rateMin: double.parse(json[RATEMIN]),
        rateType: json[RATE_TYPE],
        timing: json[TIMING],
        formats: json[CLASS_FORMATS],
        qualifications: json[QUALIFICATIONS],
        sellingPoints: json[SELLING_POINTS],
        location: json[LOCATION],
        isPublic: json[IS_PUBLIC],
        numClicks: json[NUM_CLICKS],
        numRequest: json[NUM_REQUEST],
        numLiked: json[NUM_LIKED],
        rating: json[RATING],
        isVerifiedTutor: json[IS_VERIFIED_TUTOR]);

    // timeago.format(json[DATE_ADDED].toDate(), locale: 'en_short'));
  }

  factory TutorProfileEntity.fromDocumentSnapshot(
      {Map<String, dynamic> json, String postId}) {
    json.addAll(<String, String>{UID: postId});
    json[DATE_ADDED] = json[DATE_ADDED].toDate();
    json[DATE_MODIFIED] = json[DATE_MODIFIED].toDate();
    return TutorProfileEntity.fromJson(json);
  }

  factory TutorProfileEntity.fromDomainEntity(TutorProfile profile) {
    final NameEntity name = NameEntity.fromDomainEntity(profile.tutorName);
    return TutorProfileEntity(
      photoUrl: profile.photoUrl,
      uid: profile.uid,
      tutorNameModel: name,
      dateAdded: profile.dateAdded,
      dateModified: profile.dateModified,
      gender: profile.gender,
      tutorOccupation: profile.tutorOccupation,
      levelsTaught: profile.levelsTaught,
      subjects: profile.subjects,
      proposedRate: profile.proposedRate,
      rateMax: profile.rateMax,
      rateMin: profile.rateMin,
      rateType: profile.rateType,
      timing: profile.timing,
      formats: profile.formats,
      qualifications: profile.qualifications,
      sellingPoints: profile.sellingPoints,
      location: profile.location,
      isPublic: profile.isPublic,
      numClicks: profile.numClicks,
      numRequest: profile.numRequest,
      numLiked: profile.numLiked,
      rating: profile.rating,
      isVerifiedTutor: profile.isVerifiedTutor,
    );
  }

  final NameEntity _tutorNameModel;
  final String _photoUrl;
  final String _uid;
  final String _dateAdded;
  final String _dateModified;
  final String _gender;
  final String _tutorOccupation;
  final List<String> _levelsTaught;
  final List<String> _subjects;
  final double _proposedRate;
  final double _rateMin;
  final double _rateMax;
  final String _timing;
  final String _rateType;
  final List<String> _formats;
  final String _qualifications;
  final String _sellingPoints;
  final String _location;
  final bool _isPublic;
  final int _numClicks;
  final int _numRequest;
  final int _numLiked;
  final double _rating;
  final bool _isVerifiedTutor;

  @override
  String get photoUrl => _photoUrl;
  @override
  String get uid => _uid;
  @override
  NameEntity get tutorName => _tutorNameModel;
  @override
  String get dateAdded => _dateAdded;
  @override
  String get dateModified => _dateModified;
  @override
  String get gender => _gender;
  @override
  String get tutorOccupation => _tutorOccupation;
  @override
  List<String> get levelsTaught => _levelsTaught;
  @override
  List<String> get subjects => _subjects;
  @override
  double get proposedRate => _proposedRate;
  @override
  double get rateMin => _rateMin;
  @override
  double get rateMax => _rateMax;
  @override
  String get rateType => _timing;
  @override
  String get timing => _rateType;
  @override
  List<String> get formats => _formats;
  @override
  String get qualifications => _qualifications;
  @override
  String get sellingPoints => _sellingPoints;
  @override
  String get location => _location;
  @override
  bool get isPublic => _isPublic;
  @override
  int get numClicks => _numClicks;
  @override
  int get numRequest => _numRequest;
  @override
  int get numLiked => _numLiked;
  @override
  double get rating => _rating;
  @override
  bool get isVerifiedTutor => _isVerifiedTutor;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      PHOTOURL: photoUrl,
      UID: uid,
      TUTOR_NAME: _tutorNameModel.toJson(),
      DATE_ADDED: dateAdded,
      DATE_MODIFIED: dateModified,
      GENDER: gender,
      TUTOR_OCCUPATION: tutorOccupation,
      LEVELS_TAUGHT: levelsTaught,
      SUBJECTS: subjects,
      PROPOSED_RATE: proposedRate,
      RATEMIN: rateMin,
      RATEMAX: rateMax,
      RATE_TYPE: rateType,
      TIMING: timing,
      CLASS_FORMATS: formats,
      QUALIFICATIONS: qualifications,
      SELLING_POINTS: sellingPoints,
      LOCATION: location,
      IS_PUBLIC: isPublic,
      IS_VERIFIED_TUTOR: isVerifiedTutor,
      NUM_CLICKS: numClicks,
      NUM_REQUEST: numRequest,
      NUM_LIKED: numLiked,
      RATING: rating,
    };
  }

  List<dynamic> toDocumentSnapshot() {
    // TODO(ElasticBottle): figure out more things to exclude to rely on server side
    final List<String> toExclude = [
      UID,
      DATE_ADDED,
      DATE_MODIFIED,
      NUM_CLICKS,
      NUM_REQUEST,
      NUM_LIKED,
      RATING,
    ];

    final Map<String, dynamic> toUpdate = toJson();
    toUpdate.removeWhere((key, dynamic value) => toExclude.contains(key));
    return <dynamic>[uid, toUpdate];
  }

  TutorProfile toDomainEntity() {
    return TutorProfileEntity(
      photoUrl: photoUrl,
      uid: uid,
      tutorNameModel: tutorName,
      dateAdded: dateAdded,
      dateModified: dateModified,
      gender: gender,
      tutorOccupation: tutorOccupation,
      levelsTaught: levelsTaught,
      subjects: subjects,
      proposedRate: proposedRate,
      rateMax: rateMax,
      rateMin: rateMin,
      rateType: rateType,
      timing: timing,
      formats: formats,
      qualifications: qualifications,
      sellingPoints: sellingPoints,
      location: location,
      isPublic: isPublic,
      numClicks: numClicks,
      numRequest: numRequest,
      numLiked: numLiked,
      rating: rating,
      isVerifiedTutor: isVerifiedTutor,
    );
  }

  TutorProfile copyWith({
    String photoUrl,
    String uid,
    Name tutorName,
    String dateAdded,
    String dateModified,
    String gender,
    String tutorOccupation,
    List<String> levelsTaught,
    List<String> subjects,
    double proposedRate,
    double rateMin,
    double rateMax,
    String rateType,
    String timing,
    List<String> formats,
    String qualifications,
    String sellingPoints,
    String location,
    bool isPublic,
    int numClicks,
    int numRequest,
    int numLiked,
    double rating,
    bool isVerifiedTutor,
  }) {
    return TutorProfileEntity(
      photoUrl: photoUrl ?? this.photoUrl,
      uid: uid ?? this.uid,
      tutorNameModel: tutorName ?? this.tutorName,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      gender: gender ?? this.gender,
      tutorOccupation: tutorOccupation ?? this.tutorOccupation,
      levelsTaught: levelsTaught ?? this.levelsTaught,
      subjects: subjects ?? this.subjects,
      proposedRate: proposedRate ?? this.proposedRate,
      rateMin: rateMin ?? this.rateMin,
      rateMax: rateMax ?? this.rateMax,
      rateType: rateType ?? this.rateType,
      timing: timing ?? this.timing,
      formats: formats ?? this.formats,
      qualifications: qualifications ?? this.qualifications,
      sellingPoints: sellingPoints ?? this.sellingPoints,
      location: location ?? this.location,
      isPublic: isPublic ?? this.isPublic,
      numClicks: numClicks ?? this.numClicks,
      numRequest: numRequest ?? this.numRequest,
      numLiked: numLiked ?? this.numLiked,
      rating: rating ?? this.rating,
      isVerifiedTutor: isVerifiedTutor ?? this.isVerifiedTutor,
    );
  }

  @override
  List<Object> get props => [
        photoUrl,
        uid,
        tutorName,
        dateAdded,
        dateModified,
        gender,
        tutorOccupation,
        levelsTaught,
        subjects,
        proposedRate,
        rateMin,
        rateMax,
        rateType,
        timing,
        formats,
        qualifications,
        sellingPoints,
        location,
        isPublic,
        numClicks,
        numRequest,
        numLiked,
        rating,
        isVerifiedTutor,
      ];

  @override
  String toString() => '''TutorProfile {
    photoUrl : $photoUrl ,
    uid : $uid ,
    tutorName : $tutorName ,
    dateAdded : $dateAdded ,
    dateModified: $dateModified,
    gender : $gender ,
    tutorOccupation : $tutorOccupation ,
    levelsTaught : $levelsTaught ,
    subjects : $subjects ,
    proposedRate : $proposedRate ,
    rateMin : $rateMin ,
    rateMax : $rateMax ,
    rateType : $rateType,
    timing : $timing ,
    format : $formats ,
    qualifications : $qualifications,
    sellingPoints : $sellingPoints ,
    location : $location ,
    isPublic : $isPublic ,
    numClicks: $numClicks,
    numRequest : $numRequest ,
    numLiked : $numLiked ,
    rating : $rating ,
    isVerifiedTutor: $isVerifiedTutor,}
    ''';
}
