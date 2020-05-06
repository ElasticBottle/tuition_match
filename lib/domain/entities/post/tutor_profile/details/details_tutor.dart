import 'package:cotor/domain/entities/core/details_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/subject_area.dart';
import 'package:cotor/domain/entities/post/base_post/tutor_occupation.dart';
import 'package:cotor/domain/entities/post/tutor_profile/details/qualifications.dart';
import 'package:cotor/domain/entities/post/tutor_profile/details/selling_points.dart';

abstract class DetailsTutor extends DetailsBase {
  TutorOccupation get occupation;
  Level get levelsTaught;
  SubjectArea get subjectsTaught;
  Qualifications get qualification;
  SellingPoints get sellingPoints;
}
