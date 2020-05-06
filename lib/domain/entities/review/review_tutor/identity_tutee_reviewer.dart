import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/level.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/subject_area.dart';

abstract class IdentityTuteeReviewer extends IdentityBase {
  Level get levels;
  SubjectArea get subject;
}
