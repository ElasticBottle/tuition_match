import 'package:cotor/domain/entities/stats/stats_base.dart';

abstract class StatsTutee extends StatsBase {
  Map<DateTime, int> get incomingApplication;

  Map<DateTime, int> get awaitingReview;
  Map<DateTime, int> get awaitingOtherPartyConfirm;

  Map<DateTime, int> get outgoingApplication;
  Map<DateTime, int> get awaitingUserConfirm;
}
