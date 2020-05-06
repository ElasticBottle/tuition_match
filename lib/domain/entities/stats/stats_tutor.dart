import 'package:cotor/domain/entities/stats/stats_base.dart';

abstract class StatsTutor extends StatsBase {
  Map<DateTime, int> get incomingApplication;

  Map<DateTime, int> get pastStudents;
  Map<DateTime, int> get currentStudents;

  Map<DateTime, int> get awaitingReview;
  Map<DateTime, int> get awaitingOtherPartyConfirm;

  Map<DateTime, int> get outgoingApplication;
  Map<DateTime, int> get awaitingUserConfirm;
}
