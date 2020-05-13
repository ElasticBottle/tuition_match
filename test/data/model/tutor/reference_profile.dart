import 'package:cotor/data/models/post/base_post/base_details/date_details_entity.dart';
import 'package:cotor/data/models/post/base_post/base_details/level_entity.dart';
import 'package:cotor/data/models/post/base_post/base_details/subject_area_entity.dart';
import 'package:cotor/data/models/post/base_post/base_identity/name_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/class_format_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/location_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/price_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/rate_types_entity.dart';
import 'package:cotor/data/models/post/base_post/base_requirements/timing_entity.dart';
import 'package:cotor/data/models/post/base_post/base_stats/stats_simple_entity.dart';
import 'package:cotor/data/models/post/base_post/gender_entity.dart';
import 'package:cotor/data/models/post/base_post/tutor_occupation_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/details/details_tutor_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/details/qualifications_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/details/selling_points_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/identity/identity_tutors_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/requirements/requirements_tutor_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/tutor_profile_entity.dart';
import 'package:cotor/data/models/user/account_type_entity.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';

class ReferenceProfile {
  ReferenceProfile();

  static final IdentityTutor testIdentityTutor = IdentityTutor(
    name: Name(
      firstName: 'John',
      lastName: 'Tan',
    ),
    photoUrl:
        'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
    isOpen: true,
    gender: Gender.MALE,
    accountType: AccountType.BASIC,
    uid: '12345',
  );

  static final IdentityTutorEntity testIdentityTutorEntity =
      IdentityTutorEntity(
    name: NameEntity(
      firstName: 'John',
      lastName: 'Tan',
    ),
    photoUrl:
        'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
    isOpen: true,
    gender: GenderEntity.fromDomainEntity(Gender.MALE),
    accountType: AccountTypeEntity.fromDomainEntity(AccountType.BASIC),
    uid: '12345',
  );

  static DetailsTutor testDetailsTutor = DetailsTutor(
    levelsTaught: [Level.PRI6, Level.PRI5],
    subjectsTaught: [Science.SCIENCE, Math.MATH]
        .map((e) => SubjectArea(e.toString()))
        .toList(),
    qualification: Qualifications(qualifications: 'Top scorer'),
    sellingPoints: SellingPoints(
        sellingPt: 'Three previous tutess, all scored failing grades'),
    tutorOccupation: TutorOccupation.PART_TIME,
    dateDetails: DateDetails(
      dateAdded: DateTime.parse('2020-05-13 23:07:24.000'),
      dateModified: DateTime.parse('2020-05-13 23:07:24.000'),
    ),
  );

  static final DetailsTutorEntity testDetailsTutorEntity = DetailsTutorEntity(
    levelsTaught: [Level.PRI6, Level.PRI5]
        .map((e) => LevelEntity.fromDomainEntity(e))
        .toList(),
    subjectsTaught: [Science.SCIENCE, Math.MATH]
        .map((e) => SubjectAreaEntity.fromDomainEntity(e))
        .toList(),
    qualification: QualificationsEntity(qualifications: 'Top scorer'),
    sellingPoints: SellingPointsEntity(
        sellingPt: 'Three previous tutess, all scored failing grades'),
    tutorOccupation:
        TutorOccupationEntity.fromDomainEntity(TutorOccupation.PART_TIME),
    dateDetails: DateDetailsEntity(
      dateAdded: DateTime.parse('2020-05-13 23:07:24.000'),
      dateModified: DateTime.parse('2020-05-13 23:07:24.000'),
    ),
  );

  static final RequirementsTutor testRequirementsTutor = RequirementsTutor(
    classFormat: [ClassFormat.ONLINE, ClassFormat.PRIVATE],
    location: Location(
      location: 'Anywhere in the East, prefereably near Ang Mo Kio',
    ),
    timing: Timing(timing: 'Anytime weekdays after 2pm'),
    price: Price(
      rateType: RateTypes.HOURLY,
      maxRate: 30.0,
      minRate: 10.0,
      proposedRate: 0.0,
    ),
  );

  static final RequirementsTutorEntity testRequirementsTutorEntity =
      RequirementsTutorEntity(
    classFormat: [ClassFormat.ONLINE, ClassFormat.PRIVATE]
        .map((e) => ClassFormatEntity.fromDomainEntity(e))
        .toList(),
    loc: LocationEntity(
      location: 'Anywhere in the East, prefereably near Ang Mo Kio',
    ),
    timing: TimingEntity(timing: 'Anytime weekdays after 2pm'),
    price: PriceEntity(
      rateType: RateTypesEntity.fromDomainEntity(RateTypes.HOURLY),
      maxRate: 30.0,
      minRate: 10.0,
      proposedRate: 0.0,
    ),
  );

  static final StatsSimple testStats =
      StatsSimple(likeCount: 5, requestCount: 3);
  static final StatsSimpleEntity testStatsEntity =
      StatsSimpleEntity(likeCount: 5, requestCount: 3);

  static final TutorProfile testProfile = TutorProfile(
    detailsTutor: testDetailsTutor,
    identityTutor: testIdentityTutor,
    requirementsTutor: testRequirementsTutor,
    statsSimple: testStats,
  );
  static final TutorProfileEntity testProfileEntity = TutorProfileEntity(
    detailsTutor: testDetailsTutorEntity,
    identityTutor: testIdentityTutorEntity,
    requirementsTutor: testRequirementsTutorEntity,
    statsSimple: testStatsEntity,
  );
}
