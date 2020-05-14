import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/data/models/post/applications/base_application/application_dates_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('ApplicationDatesEntity', () {
    final DateTime dateTime = DateTime.parse('2020-05-13 23:07:24.000');

    ApplicationDatesEntity testDateReq;
    ApplicationDatesEntity testDateReqStart;
    ApplicationDatesEntity testDateReqStartEnd;
    ApplicationDatesEntity testDateReqDeclined;

    setUp(() {
      testDateReq = ApplicationDatesEntity(
        dateRequest: dateTime,
      );
      testDateReqStart = ApplicationDatesEntity(
        dateRequest: dateTime,
        dateStart: dateTime,
      );
      testDateReqStartEnd = ApplicationDatesEntity(
        dateRequest: dateTime,
        dateStart: dateTime,
        dateEnd: dateTime,
      );
      testDateReqDeclined = ApplicationDatesEntity(
        dateRequest: dateTime,
        dateDeclined: dateTime,
      );
    });
    group('json conversion', () {
      Map<String, dynamic> testMapReq;
      Map<String, dynamic> testMapReqStart;
      Map<String, dynamic> testMapReqStartEnd;
      Map<String, dynamic> testMapReqDeclined;
      setUp(() {
        testMapReq = json.decode(
          fixture('application_dates/application_dates_entity_initial.json'),
        );
        testMapReqStart = json.decode(
          fixture('application_dates/application_dates_entity_start.json'),
        );
        testMapReqStartEnd = json.decode(
          fixture('application_dates/application_dates_entity_end.json'),
        );
        testMapReqDeclined = json.decode(
          fixture('application_dates/application_dates_entity_decline.json'),
        );
      });
      group('fromJson', () {
        test(
            'should return valid ApplicationDatesEntity from valid JSON contains only [dateRequested] and null for the rest',
            () {
          // act
          final ApplicationDatesEntity test =
              ApplicationDatesEntity.fromJson(testMapReq);

          // assert
          expect(test, testDateReq);
        });
        test(
            'should return valid ApplicationDatesEntity from valid JSON contains only [dateRequested] and [dateStart], null for the rest',
            () {
          // act
          final ApplicationDatesEntity test =
              ApplicationDatesEntity.fromJson(testMapReqStart);

          // assert
          expect(test, testDateReqStart);
        });
        test(
            'should return valid ApplicationDatesEntity from valid JSON contains only [dateRequested], [dateStart], and [dateEnd], null for the [dateDeclined]',
            () {
          // act
          final ApplicationDatesEntity test =
              ApplicationDatesEntity.fromJson(testMapReqStartEnd);

          // assert
          expect(test, testDateReqStartEnd);
        });
        test(
            'should return valid ApplicationDatesEntity from valid JSON contains only [dateRequested] and [dateDeclined], null for the rest',
            () {
          // act
          final ApplicationDatesEntity test =
              ApplicationDatesEntity.fromJson(testMapReqDeclined);

          // assert
          expect(test, testDateReqDeclined);
        });

        test('should return null when passed with emtpy json', () {
          // act
          final ApplicationDatesEntity result =
              ApplicationDatesEntity.fromJson(const <String, dynamic>{});

          // assert
          expect(result, null);
        });
      });
      group('toJson', () {
        test(
            'should return valid JSON containing only value for[dateRequested] and null for the rest',
            () {
          // act
          final Map<String, dynamic> test = testDateReq.toJson();

          // assert
          expect(test, testMapReq);
        });
        test(
            'should return valid JSON contains only values for [dateRequested] and [dateStart], null for the rest',
            () {
          // act
          final Map<String, dynamic> test = testDateReqStart.toJson();
          // assert
          expect(test, testMapReqStart);
        });
        test(
            'should return valid JSON contains only value [dateRequested], [dateStart], and [dateEnd], null for the [dateDeclined]',
            () {
          // act
          final Map<String, dynamic> test = testDateReqStartEnd.toJson();

          // assert
          expect(test, testMapReqStartEnd);
        });
        test(
            'should return valid  JSON contains only [dateRequested] and [dateDeclined], null for the rest',
            () {
          // act
          final Map<String, dynamic> test = testDateReqDeclined.toJson();

          // assert
          expect(test, testMapReqDeclined);
        });
      });
    });

    group('firebase Conversion', () {
      Map<String, dynamic> testMapReq;
      Map<String, dynamic> testMapReqStart;
      Map<String, dynamic> testMapReqStartEnd;
      Map<String, dynamic> testMapReqDeclined;
      setUp(() {
        testMapReq = <String, dynamic>{
          DATE_START: null,
          DATE_END: null,
          DATE_REQUEST: Timestamp.fromDate(dateTime),
          DATE_DECLINED: null,
        };
        testMapReqStart = <String, dynamic>{
          DATE_START: Timestamp.fromDate(dateTime),
          DATE_END: null,
          DATE_REQUEST: Timestamp.fromDate(dateTime),
          DATE_DECLINED: null,
        };
        testMapReqStartEnd = <String, dynamic>{
          DATE_START: Timestamp.fromDate(dateTime),
          DATE_END: Timestamp.fromDate(dateTime),
          DATE_REQUEST: Timestamp.fromDate(dateTime),
          DATE_DECLINED: null,
        };
        testMapReqDeclined = <String, dynamic>{
          DATE_START: null,
          DATE_END: null,
          DATE_REQUEST: Timestamp.fromDate(dateTime),
          DATE_DECLINED: Timestamp.fromDate(dateTime),
        };
      });
      group('fromFirebaseMap', () {
        test(
            '''should return valid ApplicationDatesEntity from valid firebaseMap 
          WITH [dateRequested] 
          AND null values from the rest''', () {
          // act
          final ApplicationDatesEntity test =
              ApplicationDatesEntity.fromFirebaseMap(testMapReq);

          // assert
          expect(test, testDateReq);
        });
        test(
            '''should return valid ApplicationDatesEntity from valid firebaseMap 
          WITH [dateRequested] and [dateStart]
          AND null values from the rest''', () {
          // act
          final ApplicationDatesEntity test =
              ApplicationDatesEntity.fromFirebaseMap(testMapReqStart);

          // assert
          expect(test, testDateReqStart);
        });
        test(
            '''should return valid ApplicationDatesEntity from valid firebaseMap 
          WITH [dateRequested], [dateStart], [dateEnd]
          AND null for [dateDeclined]''', () {
          // act
          final ApplicationDatesEntity test =
              ApplicationDatesEntity.fromFirebaseMap(testMapReqStartEnd);

          // assert
          expect(test, testDateReqStartEnd);
        });
        test(
            '''should return valid ApplicationDatesEntity from valid firebaseMap 
          WITH [dateRequested], [dateDeclined]
          AND null values from the rest''', () {
          // act
          final ApplicationDatesEntity test =
              ApplicationDatesEntity.fromFirebaseMap(testMapReqDeclined);

          // assert
          expect(test, testDateReqDeclined);
        });

        test('should return null when passed with emtpy json', () {
          // act
          final ApplicationDatesEntity result =
              ApplicationDatesEntity.fromFirebaseMap(const <String, dynamic>{});

          // assert
          expect(result, null);
        });
      });
      group('toFirebaseMap', () {
        test(
            '''should return current Timestamp for [dateRequested] if [ApplicationDateType] is [request]''',
            () {
          // arrnage
          final ApplicationDatesEntity test = ApplicationDatesEntity();
          testMapReq[DATE_REQUEST] = FieldValue.serverTimestamp();
          // act
          final Map<String, dynamic> result =
              test.toFirebaseMap(dateType: ApplicationDateType.request);

          // assert
          expect(result, testMapReq);
        });
        test('''should return past value for [dateRequest]
            AND current Timestamp for [dateStart] if [ApplicationDateType] is [start]''',
            () {
          // arrnage
          testMapReqStart[DATE_START] = FieldValue.serverTimestamp();

          // act
          final Map<String, dynamic> result = testDateReqStart.toFirebaseMap(
              dateType: ApplicationDateType.start);

          // assert
          expect(result, testMapReqStart);
        });
        test('''should return past value for [dateRequested], [dateStart]
            AND current Timestamp for [dateEnd] if [ApplicationDateType] is [end]''',
            () {
          // arrnage
          testMapReqStartEnd[DATE_END] = FieldValue.serverTimestamp();
          // act
          final Map<String, dynamic> result = testDateReqStartEnd.toFirebaseMap(
              dateType: ApplicationDateType.end);

          // assert
          expect(result, testMapReqStartEnd);
        });
        test('''should return past value for [dateRequested]
            AND current Timestamp for [dateDeclined] is [ApplicationDateType] is [decline]''',
            () {
          // arrnage
          testMapReqDeclined[DATE_DECLINED] = FieldValue.serverTimestamp();
          // act
          final Map<String, dynamic> result = testDateReqDeclined.toFirebaseMap(
              dateType: ApplicationDateType.decline);

          // assert
          expect(result, testMapReqDeclined);
        });
      });
    });
  });
}
