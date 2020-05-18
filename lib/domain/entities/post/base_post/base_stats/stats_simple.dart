import 'package:equatable/equatable.dart';

class StatsSimple extends Equatable {
  const StatsSimple({
    int likeCount = 0,
    int requestCount = 0,
  })  : _likeCount = likeCount,
        _requestCount = requestCount;

  final int _likeCount;
  final int _requestCount;

  int get likeCount => _likeCount;
  int get requestCount => _requestCount;

  @override
  List<Object> get props => [likeCount, requestCount];

  @override
  String toString() =>
      'StatsSimple(likeCount: $likeCount, requestCount: $requestCount)';
}
