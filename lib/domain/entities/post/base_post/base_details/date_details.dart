import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class DateDetails extends Equatable {
  const DateDetails({
    @required DateTime dateAdded,
    @required DateTime dateModified,
  })  : _dateAdded = dateAdded,
        _dateModified = dateModified;

  final DateTime _dateAdded;
  final DateTime _dateModified;

  DateTime get dateAdded => _dateAdded;
  DateTime get dateModified => _dateModified;

  @override
  String toString() =>
      'DateDetails(dateAdded: $dateAdded, dateModified: $dateModified)';

  @override
  List<Object> get props => [
        dateAdded,
        dateModified,
      ];
}
