import 'package:cotor/domain/entities/post/base_post/post_base.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_type_exports.dart';
import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/post/tutor_profile/details/details_tutor.dart';
import 'package:cotor/domain/entities/post/tutor_profile/identity/identity_tutor.dart';
import 'package:cotor/domain/entities/post/tutor_profile/requirements/requirements_tutor.dart';
import 'package:cotor/domain/entities/post/base_post/base_stats/stats_simple.dart';

class TutorProfile extends Equatable implements PostBase {
  const TutorProfile({
    IdentityTutor identityTutor,
    DetailsTutor detailsTutor,
    RequirementsTutor requirementsTutor,
    StatsSimple statsSimple,
  })  : _detailsTutor = detailsTutor,
        _identityTutor = identityTutor,
        _requirementsTutor = requirementsTutor,
        _statsSimple = statsSimple;

  final IdentityTutor _identityTutor;
  final DetailsTutor _detailsTutor;
  final RequirementsTutor _requirementsTutor;
  final StatsSimple _statsSimple;
  @override
  bool get isAssignment => false;
  @override
  bool get isProfile => true;

  @override
  IdentityTutor get identity => _identityTutor;

  @override
  DetailsTutor get details => _detailsTutor;

  @override
  RequirementsTutor get requirements => _requirementsTutor;

  @override
  StatsSimple get stats => _statsSimple;

  // IDENTITY
  String get photoUrl => identity.photoUrl;

  String get uid => identity.uid;

  Name get name => identity.name;

  Gender get gender => identity.gender;

  bool get isOpen => identity.isOpen;

  bool get isVerifiedTutor => identity.isVerifiedTutor;

  // DETAILS
  List<Level> get levelsTaught => details.levelsTaught;

  SellingPoints get sellingPoints => details.sellingPoints;

  TutorOccupation get occupation => details.occupation;

  Qualifications get qualification => details.qualification;

  List<SubjectArea> get subjectsTaught => details.subjectsTaught;

  // REQUIREMENTS
  List<ClassFormat> get classFormat => requirements.classFormat;

  Location get location => requirements.location;

  double get maxRate => requirements.price.maxRate;

  double get minRate => requirements.price.minRate;

  double get proposedRate => requirements.price.proposedRate;

  RateTypes get rateType => requirements.price.rateType;

  Timing get timing => requirements.timing;

  @override
  List<Object> get props =>
      [_detailsTutor, _requirementsTutor, _identityTutor, _statsSimple];

  @override
  String toString() => '''TutorProfile(
        detailsTutor: $details, 
        identityTutor: $identity, 
        requirementsTutor: $requirements
        statsSimple: $stats
      )''';
}
