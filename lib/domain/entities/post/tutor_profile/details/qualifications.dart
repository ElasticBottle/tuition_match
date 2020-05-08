import 'package:equatable/equatable.dart';

class Qualifications extends Equatable {
  const Qualifications({String qualifications})
      : _qualifications = qualifications;

  final String _qualifications;

  String get qualifications => _qualifications;

  @override
  List<Object> get props => [_qualifications];

  @override
  String toString() => _qualifications;
}
