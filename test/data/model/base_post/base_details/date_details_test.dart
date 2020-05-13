import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_details/date_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('DateDetailsEntity', () {
    final DateTime dateTime =
        Timestamp.fromMillisecondsSinceEpoch(1589382444000).toDate();

    final DateDetailsEntity testDateDetailsEntity =
        DateDetailsEntity(dateAdded: dateTime, dateModified: dateTime);
    group('fromJson', () {
      test('should return valid DateDetailEntity from valid JSon', () {
        // arrange
        final Map<String, dynamic> toConvert = json.decode(
          fixture('date_details_entity.json'),
        );

        // act
        final DateDetailsEntity test = DateDetailsEntity.fromJson(toConvert);

        // assert
        expect(test, testDateDetailsEntity);
      });
      test('should return null when passed with emtpy json', () {
        // act
        final DateDetailsEntity result =
            DateDetailsEntity.fromJson(const <String, dynamic>{});

        // assert
        expect(result, null);
      });
    });
    group('toJson', () {
      test('should return valid json ', () {
        // arrange
        final Map<String, dynamic> actual = json.decode(
          fixture('date_details_entity.json'),
        ); // act

        // act
        final Map<String, dynamic> test = testDateDetailsEntity.toJson();

        // assert
        expect(test, actual);
      });
    });

    group('fromFirebaseMap', () {
      test('should return valid DateDetailEntity from valid JSon', () {
        // arrange
        final Map<String, dynamic> toConvert = <String, dynamic>{
          DATE_CREATED: Timestamp.fromMillisecondsSinceEpoch(1589382444000),
          DATE_MODIFIED: Timestamp.fromMillisecondsSinceEpoch(1589382444000),
        };

        // act
        final DateDetailsEntity test =
            DateDetailsEntity.fromFirebaseMap(toConvert);

        // assert
        expect(test, testDateDetailsEntity);
      });
      test('should return null when passed with emtpy json', () {
        // act
        final DateDetailsEntity result =
            DateDetailsEntity.fromFirebaseMap(const <String, dynamic>{});

        // assert
        expect(result, null);
      });
    });
    group('toFirebaseMap', () {
      test(
          'should return current Timestamp for both dateAdded and dateModified if [isNew] is true',
          () {
        // arrnage
        final DateDetailsEntity test = DateDetailsEntity();

        // act
        final Map<String, dynamic> result = test.toFirebaseMap(isNew: true);

        // assert
        expect(result, <String, dynamic>{
          DATE_CREATED: FieldValue.serverTimestamp(),
          DATE_MODIFIED: FieldValue.serverTimestamp(),
        });
      });
      test(
          'should return original TimeStamp for dateAdded and current Timestamp for dateModified if [isNew] is false',
          () {
        // act
        final Map<String, dynamic> result =
            testDateDetailsEntity.toFirebaseMap(isNew: false);

        // assert
        expect(result, <String, dynamic>{
          DATE_CREATED: Timestamp.fromDate(dateTime),
          DATE_MODIFIED: FieldValue.serverTimestamp(),
        });
      });
    });
  });
}
