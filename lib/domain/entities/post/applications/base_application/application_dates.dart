import 'package:equatable/equatable.dart';

class ApplicationDates extends Equatable {
  const ApplicationDates({
    DateTime dateStart,
    DateTime dateEnd,
    DateTime dateRequest,
    DateTime dateDeclined,
  })  : _dateStart = dateStart,
        _dateEnd = dateEnd,
        _dateRequest = dateRequest,
        _dateDeclined = dateDeclined;

  final DateTime _dateStart;
  final DateTime _dateEnd;
  final DateTime _dateRequest;
  final DateTime _dateDeclined;

  DateTime get dateStart => _dateStart;
  DateTime get dateEnd => _dateEnd;
  DateTime get dateRequest => _dateRequest;
  DateTime get dateDeclined => _dateDeclined;

  @override
  List<Object> get props => [
        dateStart,
        dateEnd,
        dateRequest,
        dateDeclined,
      ];

  @override
  String toString() => '''DateDetails(
        dateStart: $dateStart, 
        dateEnd: $dateEnd, 
        dateRequst: $dateRequest,
        dateDeclined: $dateDeclined,
      )''';
}
