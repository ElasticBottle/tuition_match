import 'package:equatable/equatable.dart';

class ApplicationDates extends Equatable {
  const ApplicationDates({
    DateTime dateStart,
    DateTime dateEnd,
    DateTime dateRequest,
  })  : _dateStart = dateStart,
        _dateEnd = dateEnd,
        _dateRequest = dateRequest;

  final DateTime _dateStart;
  final DateTime _dateEnd;
  final DateTime _dateRequest;

  DateTime get dateStart => _dateStart;
  DateTime get dateEnd => _dateEnd;
  DateTime get dateRequest => _dateRequest;

  @override
  List<Object> get props => [
        dateStart,
        dateEnd,
        dateRequest,
      ];

  @override
  String toString() => '''DateDetails(
        dateStart: $dateStart, 
        dateEnd: $dateEnd, 
        dateRequst: $dateRequest
      )''';
}
