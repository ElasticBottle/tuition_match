import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/domain/entities/post/base_post/base_details/date_details.dart';

class DateDetailsEntity extends DateDetails implements EntityBase<DateDetails> {
  const DateDetailsEntity({
    DateTime dateAdded,
    DateTime dateModified,
  }) : super(
          dateAdded: dateAdded,
          dateModified: dateModified,
        );

  factory DateDetailsEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return DateDetailsEntity(
      dateAdded: DateTime.parse(json[DATE_CREATED]),
      dateModified: DateTime.parse(json[DATE_MODIFIED]),
    );
  }

  factory DateDetailsEntity.fromFirebaseMap(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return DateDetailsEntity(
      dateAdded: json[DATE_CREATED].toDate(),
      dateModified: json[DATE_MODIFIED].toDate(),
    );
    // timeago.format(json[DATE_MODIFIED].toDate(), locale: 'en_short'));
  }

  factory DateDetailsEntity.fromDomainEntity(DateDetails dateDetails) {
    return DateDetailsEntity(
      dateAdded: dateDetails.dateAdded,
      dateModified: dateDetails.dateModified,
    );
  }

  @override
  DateDetails toDomainEntity() {
    return DateDetails(
      dateAdded: dateAdded,
      dateModified: dateModified,
    );
  }

  Map<String, String> toJson() {
    return <String, String>{
      DATE_CREATED: dateAdded.toString(),
      DATE_MODIFIED: dateModified.toString(),
    };
  }

  Map<String, dynamic> toFirebaseMap({bool isNew}) {
    return <String, dynamic>{
      DATE_CREATED:
          isNew ? FieldValue.serverTimestamp() : Timestamp.fromDate(dateAdded),
      DATE_MODIFIED: FieldValue.serverTimestamp(),
    };
  }
}
