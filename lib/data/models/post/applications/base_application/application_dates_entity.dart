import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/domain/entities/post/applications/base_application/application_dates.dart';

class ApplicationDatesEntity extends ApplicationDates
    implements EntityBase<ApplicationDates> {
  const ApplicationDatesEntity({
    DateTime dateStart,
    DateTime dateEnd,
    DateTime dateRequest,
    DateTime dateDeclined,
  }) : super(
          dateStart: dateStart,
          dateEnd: dateEnd,
          dateRequest: dateRequest,
          dateDeclined: dateDeclined,
        );

  factory ApplicationDatesEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return ApplicationDatesEntity(
      dateStart: DateTime.tryParse(json[DATE_START] ?? ''),
      dateEnd: DateTime.tryParse(json[DATE_END] ?? ''),
      dateRequest: DateTime.tryParse(json[DATE_REQUEST]),
      dateDeclined: DateTime.tryParse(json[DATE_DECLINED] ?? ''),
    );
  }
  factory ApplicationDatesEntity.fromFirebaseMap(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }

    return ApplicationDatesEntity(
      dateStart: json[DATE_START]?.toDate(),
      dateEnd: json[DATE_END]?.toDate(),
      dateRequest: json[DATE_REQUEST].toDate(),
      dateDeclined: json[DATE_DECLINED]?.toDate(),
    );
    // timeago.format(json[DATE_ADDED].toDate(), locale: 'en_short'));
  }

  factory ApplicationDatesEntity.fromDomainEntity(
      ApplicationDates applicationDates) {
    return ApplicationDatesEntity(
      dateStart: applicationDates.dateStart,
      dateEnd: applicationDates.dateEnd,
      dateRequest: applicationDates.dateRequest,
      dateDeclined: applicationDates.dateDeclined,
    );
  }

  @override
  ApplicationDates toDomainEntity() {
    return ApplicationDates(
      dateStart: dateStart,
      dateEnd: dateEnd,
      dateRequest: dateRequest,
      dateDeclined: dateDeclined,
    );
  }

  Map<String, String> toJson() {
    return <String, String>{
      DATE_START: dateStart?.toString(),
      DATE_END: dateEnd?.toString(),
      DATE_REQUEST: dateRequest.toString(),
      DATE_DECLINED: dateDeclined?.toString(),
    };
  }

  Map<String, dynamic> toFirebaseMap({
    // Map<String, dynamic> existingData = const <String, FieldValue>{},
    ApplicationDateType dateType,
  }) {
    dynamic startD = dateStart != null ? Timestamp.fromDate(dateStart) : null;
    dynamic endD = dateEnd != null ? Timestamp.fromDate(dateEnd) : null;
    dynamic requestD =
        dateRequest != null ? Timestamp.fromDate(dateRequest) : null;
    dynamic declineD =
        dateDeclined != null ? Timestamp.fromDate(dateDeclined) : null;

    switch (dateType) {
      case ApplicationDateType.start:
        startD = FieldValue.serverTimestamp();
        break;
      case ApplicationDateType.end:
        endD = FieldValue.serverTimestamp();
        break;
      case ApplicationDateType.request:
        requestD = FieldValue.serverTimestamp();
        break;
      case ApplicationDateType.decline:
        declineD = FieldValue.serverTimestamp();
        break;
      case ApplicationDateType.noChange:
        break;
    }

    return <String, dynamic>{
      DATE_START: startD,
      DATE_END: endD,
      DATE_REQUEST: requestD,
      DATE_DECLINED: declineD,
    };
  }

  @override
  String toString() => '''DateDetailsEntity(
        dateStart: $dateStart, 
        dateEnd: $dateEnd, 
        dateRequst: $dateRequest
        dateDeclined: $dateDeclined,
      )''';
}
