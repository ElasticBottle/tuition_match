import 'package:equatable/equatable.dart';

class AdditionalRemarks extends Equatable {
  const AdditionalRemarks({String remark}) : _remark = remark;

  final String _remark;

  String get remarks => _remark;

  @override
  List<Object> get props => [_remark];

  @override
  String toString() => _remark;
}
