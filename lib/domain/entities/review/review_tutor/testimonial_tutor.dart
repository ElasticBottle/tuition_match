import 'package:cotor/domain/entities/post/tutee_assignment/details/grade_records.dart';
import 'package:cotor/domain/entities/review/major_event.dart';
import 'package:cotor/domain/entities/review/testimonial_base.dart';

abstract class TestimonialTutor extends TestimonialBase {
  MajorEvent get majorExams;
  GradeRecords get gradeRecords;
}
