import 'package:equatable/equatable.dart';

class SellingPoints extends Equatable {
  const SellingPoints({String sellingPt}) : _sellingPt = sellingPt;

  final String _sellingPt;

  String get pointers => _sellingPt;

  @override
  List<Object> get props => [_sellingPt];

  @override
  String toString() => _sellingPt;
}
