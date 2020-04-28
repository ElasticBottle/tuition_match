import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/models/name_model.dart';
import 'package:equatable/equatable.dart';
import 'package:timeago/timeago.dart' as timeago;

class TuteeAssignmentModel extends Equatable implements TuteeAssignment {
  TuteeAssignmentModel({
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
        _tuteeNameModel = NameModel.fromDomainEntity(tuteeNameModel),
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

  factory TuteeAssignmentModel.fromDomainEntity(TuteeAssignment assignment) {
    if (assignment == null) {
      return null;
    }
    return TuteeAssignmentModel(
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
  final NameModel _tuteeNameModel;
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
  NameModel get tuteeName => _tuteeNameModel;
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

  TuteeAssignment toDomainEntity() {
    return TuteeAssignmentModel(
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

  bool isEmpty() {
    return uid == null;
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
    return TuteeAssignmentModel(
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
  String toString() => '''TuteeAssignment {
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
