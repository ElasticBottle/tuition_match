abstract class DetailStatsbase {
  Map<DateTime, String> get likes;
  Map<DateTime, String> get otherDeclined;
  Map<DateTime, String> get otherAccepted;
  Map<DateTime, String> get incoming;
  Map<DateTime, String> get outgoing;
  Map<String, int> get pending;
}
