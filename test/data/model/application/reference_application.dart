import 'package:cotor/data/models/post/applications/base_application/application_dates_entity.dart';
import 'package:cotor/data/models/post/applications/base_application/application_status_entity.dart';
import 'package:cotor/data/models/post/applications/tutee_application/tutee_application_entity.dart';
import 'package:cotor/data/models/post/applications/tutor_application/tutor_application_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/tutor_profile_entity.dart';
import 'package:cotor/domain/entities/post/applications/application.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_status.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';

import '../tutee/reference_assignment.dart';
import '../tutor/reference_profile.dart';

class ReferenceApplication {
  ReferenceApplication();
  static final DateTime dateTime = DateTime.parse('2020-05-13 23:07:24.000');

  static final ApplicationDates testApplicationDates = ApplicationDates(
    dateRequest: dateTime,
    dateStart: dateTime,
  );
  static final ApplicationDatesEntity testApplicationDatesEntity =
      ApplicationDatesEntity(
    dateRequest: dateTime,
    dateStart: dateTime,
  );

  static final ApplicationStatus testApplicationStatus =
      ApplicationStatus.ACCEPTED;
  static final ApplicationStatusEntity testApplicationStatusEntity =
      ApplicationStatusEntity.fromDomainEntity(testApplicationStatus);

  static final Application testTuteeApplication = Application<TuteeAssignment>(
    application: TuteeAssignment(
      detailsTutee: ReferenceAssignment.testAssignment.details,
      identityTutee: ReferenceAssignment.testAssignment.identity,
      requirementsTutee: ReferenceAssignment.testAssignment.requirements,
    ),
    applicationDates: testApplicationDates,
    applicationStatus: testApplicationStatus,
  );
  static final TuteeApplicationEntity testTuteeApplicationEntity =
      TuteeApplicationEntity(
    application: TuteeAssignmentEntity(
      detailsTutee: ReferenceAssignment.testAssignmentEntity.details,
      identityTutee: ReferenceAssignment.testAssignmentEntity.identity,
      requirementsTutee: ReferenceAssignment.testAssignmentEntity.requirements,
    ),
    applicationDates: testApplicationDatesEntity,
    applicationStatus: testApplicationStatusEntity,
  );

  static final Application testTutorApplication = Application<TutorProfile>(
    application: TutorProfile(
      detailsTutor: ReferenceProfile.testProfile.details,
      identityTutor: ReferenceProfile.testProfile.identity,
      requirementsTutor: ReferenceProfile.testProfile.requirements,
    ),
    applicationDates: testApplicationDates,
    applicationStatus: testApplicationStatus,
  );
  static final TutorApplicationEntity testTutorApplicationEntity =
      TutorApplicationEntity(
    application: TutorProfileEntity(
      detailsTutor: ReferenceProfile.testProfileEntity.details,
      identityTutor: ReferenceProfile.testProfileEntity.identity,
      requirementsTutor: ReferenceProfile.testProfileEntity.requirements,
    ),
    applicationDates: testApplicationDatesEntity,
    applicationStatus: testApplicationStatusEntity,
  );
}
