import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/name_entity.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:equatable/equatable.dart';
import 'package:timeago/timeago.dart' as timeago;

class TuteeAssignmentEntity extends Equatable implements TuteeAssignment {
  TuteeAssignmentEntity({
    String postId,
    String photoUrl,
    String uid,
    Name tuteeNameModel,
    List<String> tutorGender,
    List<String> levels,
    List<String> subjects,
    List<String> formats,
    List<String> tutorOccupation,
    String timing,
    String location,
    String freq,
    double proposedRate,
    double rateMin,
    double rateMax,
    String rateType,
    String additionalRemarks,
    bool isOpen,
    bool isPublic,
    int numApplied,
    int numLiked,
    String dateAdded,
    bool isVerifiedAccount,
  })  : _postId = postId,
        _photoUrl = photoUrl,
        _uid = uid,
        _tuteeNameModel = NameEntity.fromDomainEntity(tuteeNameModel),
        _tutorGender = tutorGender,
        _levels = levels,
        _subjects = subjects,
        _formats = formats,
        _tutorOccupation = tutorOccupation,
        _timing = timing,
        _location = location,
        _freq = freq,
        _proposedRate = proposedRate,
        _rateMin = rateMin,
        _rateMax = rateMax,
        _rateType = rateType,
        _additionalRemarks = additionalRemarks,
        _isOpen = isOpen,
        _isPublic = isPublic,
        _numApplied = numApplied,
        _numLiked = numLiked,
        _dateAdded = dateAdded,
        _isVerifiedAccount = isVerifiedAccount;

  factory TuteeAssignmentEntity.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return TuteeAssignmentEntity();
    }
    return TuteeAssignmentEntity(
      postId: json[POSTID],
      tuteeNameModel: NameEntity.fromJson(json[TUTEE_NAME]),
      photoUrl: json[PHOTOURL],
      uid: json[UID],
      tutorGender: json[TUTOR_GENDER].cast<String>(),
      levels: json[LEVELS].cast<String>(),
      tutorOccupation: json[TUTOR_OCCUPATIONS].cast<String>(),
      formats: json[CLASS_FORMATS].cast<String>(),
      subjects: json[SUBJECTS].cast<String>(),
      freq: json[FREQ],
      timing: json[TIMING],
      location: json[LOCATION],
      proposedRate: json[PROPOSED_RATE].toDouble(),
      rateMin: json[RATEMIN].toDouble(),
      rateMax: json[RATEMAX].toDouble(),
      rateType: json[RATE_TYPE],
      additionalRemarks: json[ADDITIONAL_REMARKS],
      isOpen: json[IS_OPEN],
      isPublic: json[IS_PUBLIC],
      dateAdded: json[DATE_ADDED].toString(),
      numLiked: json[NUM_LIKED],
      numApplied: json[NUM_APPLIED],
      isVerifiedAccount: json[IS_VERIFIED_ACCOUNT],
    );

    // timeago.format(json[DATE_ADDED].toDate(), locale: 'en_short'));
  }

  factory TuteeAssignmentEntity.fromDocumentSnapshot(
      {Map<String, dynamic> json, String postId}) {
    json.addAll(<String, String>{POSTID: postId});
    json[DATE_ADDED] = json[DATE_ADDED].toDate();
    return TuteeAssignmentEntity.fromJson(json);
  }

  factory TuteeAssignmentEntity.fromDomainEntity(TuteeAssignment assignment) {
    if (assignment == null) {
      return null;
    }
    return TuteeAssignmentEntity(
      postId: assignment.postId,
      photoUrl: assignment.photoUrl,
      uid: assignment.uid,
      tuteeNameModel: assignment.tuteeName,
      tutorGender: assignment.tutorGender,
      levels: assignment.levels,
      subjects: assignment.subjects,
      formats: assignment.formats,
      tutorOccupation: assignment.tutorOccupation,
      timing: assignment.timing,
      location: assignment.location,
      freq: assignment.freq,
      rateType: assignment.rateType,
      rateMin: assignment.rateMin,
      rateMax: assignment.rateMax,
      proposedRate: assignment.proposedRate,
      additionalRemarks: assignment.additionalRemarks,
      isOpen: assignment.isOpen,
      isPublic: assignment.isPublic,
      isVerifiedAccount: assignment.isVerifiedAccount,
      numApplied: assignment.numApplied,
      numLiked: assignment.numLiked,
      dateAdded: assignment.dateAdded,
    );
  }
  final String _postId;
  final String _photoUrl;
  final String _uid;
  final NameEntity _tuteeNameModel;
  final List<String> _tutorGender;
  final List<String> _levels;
  final List<String> _subjects;
  final List<String> _formats;
  final List<String> _tutorOccupation;
  final String _timing;
  final String _location;
  final String _freq;
  final double _proposedRate;
  final double _rateMin;
  final double _rateMax;
  final String _rateType;
  final String _additionalRemarks;
  final bool _isOpen;
  final bool _isPublic;
  final int _numApplied;
  final int _numLiked;
  final String _dateAdded;
  final bool _isVerifiedAccount;

  @override
  String get postId => _postId;
  @override
  String get photoUrl => _photoUrl;
  @override
  String get uid => _uid;
  @override
  NameEntity get tuteeName => _tuteeNameModel;
  @override
  List<String> get tutorGender => _tutorGender;
  @override
  List<String> get levels => _levels;
  @override
  List<String> get subjects => _subjects;
  @override
  List<String> get formats => _formats;
  @override
  List<String> get tutorOccupation => _tutorOccupation;
  @override
  String get timing => _timing;
  @override
  String get location => _location;
  @override
  String get freq => _freq;
  @override
  double get proposedRate => _proposedRate;
  @override
  double get rateMin => _rateMin;
  @override
  double get rateMax => _rateMax;
  @override
  String get rateType => _rateType;
  @override
  String get additionalRemarks => _additionalRemarks;
  @override
  bool get isOpen => _isOpen;
  @override
  bool get isPublic => _isPublic;
  @override
  int get numApplied => _numApplied;
  @override
  int get numLiked => _numLiked;
  @override
  String get dateAdded => _dateAdded;
  @override
  bool get isVerifiedAccount => _isVerifiedAccount;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      POSTID: postId,
      UID: uid,
      TUTEE_NAME: _tuteeNameModel?.toJson(),
      PHOTOURL: photoUrl,
      TUTOR_GENDER: tutorGender,
      TUTOR_OCCUPATIONS: tutorOccupation,
      CLASS_FORMATS: formats,
      SUBJECTS: subjects,
      LEVELS: levels,
      TIMING: timing,
      LOCATION: location,
      FREQ: freq,
      PROPOSED_RATE: proposedRate,
      RATEMIN: rateMin,
      RATEMAX: rateMax,
      RATE_TYPE: rateType,
      ADDITIONAL_REMARKS: additionalRemarks,
      IS_OPEN: isOpen,
      IS_PUBLIC: isPublic,
      NUM_LIKED: numLiked,
      NUM_APPLIED: numApplied,
      DATE_ADDED: dateAdded,
      IS_VERIFIED_ACCOUNT: isVerifiedAccount,
    };
  }

  Map<String, dynamic> toNewDocumentSnapshot() {
    final List<String> toExclude = [
      POSTID,
    ];
    final Map<String, dynamic> toUpdate = toJson();
    toUpdate.removeWhere((key, dynamic value) => toExclude.contains(key));
    toUpdate.addAll(
      <String, dynamic>{
        NUM_APPLIED: 0,
        NUM_LIKED: 0,
      },
    );
    return toUpdate;
  }

  Map<String, dynamic> toExistingDocumentSnapshot(Map<String, dynamic> data) {
    final List<String> toExclude = [
      POSTID,
    ];
    final Map<String, dynamic> toUpdate = toJson();
    toUpdate.removeWhere((key, dynamic value) => toExclude.contains(key));
    toUpdate.addAll(
      <String, dynamic>{
        DATE_ADDED: data[DATE_ADDED],
        NUM_APPLIED: data[NUM_APPLIED],
        NUM_LIKED: data[NUM_LIKED],
      },
    );
    return toUpdate;
  }

  TuteeAssignment toDomainEntity() {
    return TuteeAssignmentEntity(
      uid: uid,
      postId: postId,
      tuteeNameModel: tuteeName?.toDomainEntity(),
      photoUrl: photoUrl,
      dateAdded: dateAdded,
      tutorGender: tutorGender,
      tutorOccupation: tutorOccupation,
      formats: formats,
      levels: levels,
      subjects: subjects,
      proposedRate: proposedRate,
      rateMax: rateMax,
      rateMin: rateMin,
      rateType: rateType,
      timing: timing,
      location: location,
      freq: freq,
      additionalRemarks: additionalRemarks,
      isOpen: isOpen,
      isPublic: isPublic,
      numLiked: numLiked,
      numApplied: numApplied,
      isVerifiedAccount: isVerifiedAccount,
    );
  }

  TuteeAssignment copyWith({
    String postId,
    List<String> tutorGender,
    List<String> levels,
    List<String> subjects,
    List<String> formats,
    List<String> tutorOccupation,
    String timing,
    double proposedRate,
    double rateMin,
    double rateMax,
    String rateType,
    String location,
    String freq,
    String additionalRemarks,
    bool isOpen,
    bool isPublic,
    String uid,
    Name tuteeName,
    int numApplied,
    int numLiked,
    String photoUrl,
    String dateAdded,
    bool isVerifiedAccount,
  }) {
    return TuteeAssignmentEntity(
      postId: postId ?? this.postId,
      uid: uid ?? this.uid,
      tuteeNameModel: tuteeName ?? this.tuteeName,
      tutorGender: tutorGender ?? this.tutorGender,
      levels: levels ?? this.levels,
      subjects: subjects ?? this.subjects,
      formats: formats ?? this.formats,
      tutorOccupation: tutorOccupation ?? this.tutorOccupation,
      timing: timing ?? this.timing,
      freq: freq ?? this.freq,
      location: location ?? this.location,
      proposedRate: proposedRate ?? this.proposedRate,
      rateMax: rateMax ?? this.rateMax,
      rateMin: rateMin ?? this.rateMin,
      rateType: rateType ?? this.rateType,
      additionalRemarks: additionalRemarks ?? this.additionalRemarks,
      isOpen: isOpen ?? this.isOpen,
      isPublic: isPublic ?? this.isPublic,
      numApplied: numApplied ?? this.numApplied,
      numLiked: numLiked ?? this.numLiked,
      photoUrl: photoUrl ?? this.photoUrl,
      dateAdded: dateAdded ?? this.dateAdded,
      isVerifiedAccount: isVerifiedAccount ?? this.isVerifiedAccount,
    );
  }

  @override
  List<Object> get props => [
        postId,
        tutorGender,
        levels,
        subjects,
        formats,
        timing,
        proposedRate,
        rateMax,
        rateMax,
        rateType,
        location,
        freq,
        tutorOccupation,
        additionalRemarks,
        isOpen,
        isPublic,
        numApplied,
        uid,
        tuteeName,
        numLiked,
        photoUrl,
        dateAdded,
        isVerifiedAccount,
      ];

  @override
  String toString() => '''TuteeAssignmet {
    postId : $postId ,
    tutorGender : $tutorGender ,
    levels : $levels ,
    subject : $subjects ,
    formats : $formats ,
    timing : $timing ,
    proposedRate: $proposedRate,
    rateMin : $rateMin ,
    rateMax : $rateMax ,
    rateType : $rateType ,
    location : $location ,
    freq : $freq ,
    tutorOccupation : $tutorOccupation ,
    additionalRemarks : $additionalRemarks ,
    isOpen : $isOpen ,
    isPublic : $isPublic ,
    numApplied : $numApplied ,
    uid : $uid ,
    tuteeName : $tuteeName ,
    numLiked : $numLiked ,
    photoUrl : $photoUrl ,
    dateAdded : $dateAdded ,
    isVerifiedAccount: $isVerifiedAccount, 
    ''';
}
