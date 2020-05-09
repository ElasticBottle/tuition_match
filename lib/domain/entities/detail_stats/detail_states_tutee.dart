import 'package:cotor/domain/entities/detail_stats/detail_stats_base.dart';

class DetailStatsTutee extends DetailStatsbase {
  DetailStatsTutee({
    Map<DateTime, String> likes,
    Map<DateTime, String> incoming,
    Map<DateTime, String> outgoing,
    Map<DateTime, String> otherDeclined,
    Map<DateTime, String> otherAccept,
    Map<String, int> pending,
  })  : _likes = likes,
        _incoming = incoming,
        _outgoing = outgoing,
        _otherDeclined = otherDeclined,
        _otherAccept = otherAccept,
        _pending = pending;

  final Map<DateTime, String> _likes;
  final Map<DateTime, String> _incoming;
  final Map<DateTime, String> _outgoing;
  final Map<DateTime, String> _otherDeclined;
  final Map<DateTime, String> _otherAccept;
  final Map<String, int> _pending;

  @override
  Map<DateTime, String> get likes => _likes;

  @override
  Map<DateTime, String> get incoming => _incoming;

  @override
  Map<DateTime, String> get outgoing => _outgoing;

  @override
  Map<DateTime, String> get otherAccepted => _otherAccept;

  @override
  Map<DateTime, String> get otherDeclined => _otherDeclined;

  @override
  Map<String, int> get pending => _pending;
}
