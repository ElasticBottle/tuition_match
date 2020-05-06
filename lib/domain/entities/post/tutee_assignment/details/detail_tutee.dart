import 'package:cotor/domain/entities/core/details_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/subject_area.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/additional_remarks.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/grade_records.dart';

abstract class DetailsTutee extends DetailsBase {
  SubjectArea get subjects;
  Level get levels;
  AdditionalRemarks get additionalRemarks;
  GradeRecords get gradeRecords;
}
