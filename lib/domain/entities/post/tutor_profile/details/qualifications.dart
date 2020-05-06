import 'package:equatable/equatable.dart';

abstract class Qualifications extends Equatable {
  const Qualifications({String qualifications})
      : _qualifications = qualifications;
  final String _qualifications;

  @override
  List<Object> get props => [_qualifications];

  @override
  String toString() => _qualifications;
}
