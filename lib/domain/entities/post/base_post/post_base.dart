import 'package:cotor/domain/entities/core/details_base.dart';
import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/core/requirements_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_stats/stats_simple.dart';

abstract class PostBase {
  IdentityBase get identity;
  DetailsBase get details;
  RequirementsBase get requirements;
  StatsSimple get stats;
  bool get isAssignment;
  bool get isProfile;
}
