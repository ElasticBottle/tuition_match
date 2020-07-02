import 'package:cotor/domain/entities/post/base_post/base_stats/stats_simple.dart';
import 'package:cotor/domain/entities/post/base_post/post_base.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/details_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/identity/identity_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/requirements_tutee.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_type_exports.dart';
import 'package:equatable/equatable.dart';

class TuteeAssignment extends Equatable implements PostBase {
  const TuteeAssignment({
    DetailsTutee detailsTutee,
    IdentityTutee identityTutee,
    RequirementsTutee requirementsTutee,
    StatsSimple statsSimple,
  })  : _detailsTutee = detailsTutee,
        _identityTutee = identityTutee,
        _requirementsTutee = requirementsTutee,
        _statsSimple = statsSimple;
  factory TuteeAssignment.empty() {
    return TuteeAssignment(
      identityTutee: IdentityTutee(
        isOpen: true,
      ),
    );
  }
  final DetailsTutee _detailsTutee;
  final IdentityTutee _identityTutee;
  final RequirementsTutee _requirementsTutee;
  final StatsSimple _statsSimple;
  @override
  bool get isAssignment => true;

  @override
  bool get isProfile => false;
  @override
  DetailsTutee get details => _detailsTutee;

  @override
  IdentityTutee get identity => _identityTutee;

  @override
  RequirementsTutee get requirements => _requirementsTutee;

  @override
  StatsSimple get stats => _statsSimple;

  // IDENTITY
  String get photoUrl => identity.photoUrl;

  String get postId => identity.postId;

  String get uid => identity.uid;

  Name get name => identity.name;

  bool get isOpen => identity.isOpen;

  bool get isPublic => identity.isPublic;

  bool get isVerifiedAccount => identity.isVerifiedAccount;

  // DETAILS
  List<Level> get levels => details.levels;

  List<SubjectArea> get subjects => details.subjects;

  AdditionalRemarks get additionalRemarks => details.additionalRemarks;

  // REQUIREMENTS
  List<ClassFormat> get classFormat => requirements.classFormat;

  Frequency get freq => requirements.freq;

  Location get location => requirements.location;

  Price get price => requirements.price;

  double get maxRate => price.maxRate;

  double get minRate => price.minRate;

  double get proposedRate => price.proposedRate;

  RateTypes get rateType => price.rateType;

  Timing get timing => requirements.timing;

  List<Gender> get tutorGenders => requirements.tutorGender;

  List<TutorOccupation> get tutorOccupations => requirements.tutorOccupation;

  // STATS
  int get likeCount => stats.likeCount;

  int get applyCount => stats.requestCount;

  @override
  List<Object> get props => [
        _detailsTutee,
        _requirementsTutee,
        _identityTutee,
        _statsSimple,
      ];

  @override
  String toString() => '''TuteeAssignment(
      identityTutee: $identity,
      detailsTutee: $details,
      requirementsTutee: $requirements,
      statsSimple: $stats,
  )''';
}
