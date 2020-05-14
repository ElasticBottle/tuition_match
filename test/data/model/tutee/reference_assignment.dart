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
import 'package:cotor/data/models/post/tutee_assignment/details/additional_remarks_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/details/detail_tutee_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/details/grade_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/details/grade_records_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/indentity/identity_tutee_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/requirements/frequency_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/requirements/requirements_tutee_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/data/models/user/account_type_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';

class ReferenceAssignment {
  ReferenceAssignment();

  static final IdentityTutee testIdentityTutee = IdentityTutee(
    name: Name(
      firstName: 'John',
      lastName: 'Tan',
    ),
    photoUrl:
        'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
    uid: '12345',
    postId: 'id12345',
    isPublic: true,
    isOpen: true,
    accountType: AccountType.STUDENT,
  );
  static final IdentityTuteeEntity testIdentityTuteeEntity =
      IdentityTuteeEntity(
    name: NameEntity(
      firstName: 'John',
      lastName: 'Tan',
    ),
    photoUrl:
        'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
    uid: '12345',
    postId: 'id12345',
    isPublic: true,
    isOpen: true,
    accountType: AccountTypeEntity.fromDomainEntity(AccountType.STUDENT),
  );

  static DetailsTutee testDetailsTutee = DetailsTutee(
    dateDetails: DateDetails(
      dateAdded: DateTime.parse('2020-05-13 23:07:24.000'),
      dateModified: DateTime.parse('2020-05-13 23:07:24.000'),
    ),
    levels: [Level.PRI6],
    subjects: [Science.SCIENCE].map((e) => SubjectArea(e.toString())).toList(),
    gradeRecords: GradeRecords(start: Grade.BAND3),
    additionalRemarks: AdditionalRemarks(
        remark: 'needs someone who is pateint and can focus on dull stuff'),
  );

  static final DetailsTuteeEntity testDetailsTuteeEntity = DetailsTuteeEntity(
    dateDetails: DateDetailsEntity(
      dateAdded: DateTime.parse('2020-05-13 23:07:24.000'),
      dateModified: DateTime.parse('2020-05-13 23:07:24.000'),
    ),
    levels: [Level.PRI6].map((e) => LevelEntity.fromDomainEntity(e)).toList(),
    subjects: [Science.SCIENCE]
        .map((e) => SubjectAreaEntity.fromDomainEntity(e))
        .toList(),
    gradeRecords:
        GradeRecordsEntity(start: GradeEntity.fromDomainEntity(Grade.BAND3)),
    additionalRemarks: AdditionalRemarksEntity(
        remark: 'needs someone who is pateint and can focus on dull stuff'),
  );

  static final RequirementsTutee testRequirementsTutee = RequirementsTutee(
    classFormat: [ClassFormat.ONLINE, ClassFormat.PRIVATE],
    location: Location(
      location: 'Singapore 123456, Jurong East Ave Blk 6',
    ),
    timing: Timing(timing: 'Anytime weekdays after 2pm'),
    price: Price(
      rateType: RateTypes.HOURLY,
      maxRate: 0,
      minRate: 0,
      proposedRate: 20.0,
    ),
    freq: Frequency(freq: '1x a week'),
    tutorGenders: [Gender.MALE],
    tutorOccupations: [
      TutorOccupation.FULL_TIME,
      TutorOccupation.PART_TIME,
      TutorOccupation.MOE
    ],
  );

  static final RequirementsTuteeEntity testRequirementsTuteeEntity =
      RequirementsTuteeEntity(
    classFormat: [ClassFormat.ONLINE, ClassFormat.PRIVATE]
        .map((e) => ClassFormatEntity.fromDomainEntity(e))
        .toList(),
    loc: LocationEntity(
      location: 'Singapore 123456, Jurong East Ave Blk 6',
    ),
    timing: TimingEntity(timing: 'Anytime weekdays after 2pm'),
    price: PriceEntity(
      rateType: RateTypesEntity.fromDomainEntity(RateTypes.HOURLY),
      maxRate: 0,
      minRate: 0,
      proposedRate: 20.0,
    ),
    freq: FrequencyEntity(freq: '1x a week'),
    tutorGenders:
        [Gender.MALE].map((e) => GenderEntity.fromDomainEntity(e)).toList(),
    tutorOccupations: [
      TutorOccupation.FULL_TIME,
      TutorOccupation.PART_TIME,
      TutorOccupation.MOE
    ].map((e) => TutorOccupationEntity.fromDomainEntity(e)).toList(),
  );

  static final StatsSimple testStats =
      StatsSimple(likeCount: 5, requestCount: 3);
  static final StatsSimpleEntity testStatsEntity =
      StatsSimpleEntity(likeCount: 5, requestCount: 3);

  static final TuteeAssignment testAssignment = TuteeAssignment(
    detailsTutee: testDetailsTutee,
    identityTutee: testIdentityTutee,
    requirementsTutee: testRequirementsTutee,
    statsSimple: testStats,
  );
  static final TuteeAssignmentEntity testAssignmentEntity =
      TuteeAssignmentEntity(
    detailsTutee: testDetailsTuteeEntity,
    identityTutee: testIdentityTuteeEntity,
    requirementsTutee: testRequirementsTuteeEntity,
    statsSimple: testStatsEntity,
  );
}
