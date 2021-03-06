import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/subject_area.dart';

abstract class IdentityTutorReviewer extends IdentityBase {
  Level get levelsTaught;
  SubjectArea get subjectsTaught;
}
