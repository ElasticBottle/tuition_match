import 'package:cotor/domain/entities/detail_stats/detail_stats_base.dart';

class DetailStatsTutor extends DetailStatsbase {
  DetailStatsTutor({
    Map<DateTime, String> likes,
    Map<DateTime, String> incoming,
    Map<DateTime, String> outgoing,
    Map<DateTime, String> otherDeclined,
    Map<DateTime, String> otherAccept,
    Map<DateTime, String> accept,
    Map<DateTime, String> finished,
    Map<String, int> pending,
  })  : _likes = likes,
        _incoming = incoming,
        _outgoing = outgoing,
        _otherDeclined = otherDeclined,
        _otherAccept = otherAccept,
        _pending = pending,
        _accept = accept,
        _finished = finished;

  final Map<DateTime, String> _likes;
  final Map<DateTime, String> _incoming;
  final Map<DateTime, String> _outgoing;
  final Map<DateTime, String> _otherDeclined;
  final Map<DateTime, String> _otherAccept;
  final Map<DateTime, String> _accept;
  final Map<DateTime, String> _finished;
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

  Map<DateTime, String> get accepts => _accept;

  Map<DateTime, String> get finished => _finished;
}
