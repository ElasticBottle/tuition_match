import 'package:equatable/equatable.dart';

abstract class AdditionalRemarks extends Equatable {
  const AdditionalRemarks({String remark}) : _remark = remark;

  final String _remark;
  @override
  List<Object> get props => [_remark];

  @override
  String toString() => _remark;
}
