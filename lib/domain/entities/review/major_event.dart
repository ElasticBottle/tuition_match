import 'package:equatable/equatable.dart';

class MajorEvent extends Equatable {
  const MajorEvent._(this._exam);
  final String _exam;

  static const MajorEvent PSLE = MajorEvent._('PSLE');
  static const MajorEvent O_LEVEL = MajorEvent._('O Level');
  static const MajorEvent N_LEVEL = MajorEvent._('N Level');
  static const MajorEvent A_LEVEL = MajorEvent._('A Level');
  static const MajorEvent IB = MajorEvent._('IB');

  @override
  List<Object> get props => [_exam];

  @override
  String toString() => _exam;
}
