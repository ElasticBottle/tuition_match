import 'package:equatable/equatable.dart';

abstract class SellingPoints extends Equatable {
  const SellingPoints({String sellingPt}) : _sellingPt = sellingPt;
  final String _sellingPt;

  @override
  List<Object> get props => [_sellingPt];

  @override
  String toString() => _sellingPt;
}
