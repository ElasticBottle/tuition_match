import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/data/models/post/applications/tutee_application/tutee_application_entity.dart';
import 'package:cotor/domain/entities/post/applications/application.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../reference_application.dart';

void main() {
  group('TuteeApplicationEntity', () {
    group('fromDomainEntity', () {
      test(
          'Should return TuteeApplicationEntity from valid Application<TuteeAssignment>',
          () {
        // act
        final TuteeApplicationEntity assignment =
            TuteeApplicationEntity.fromDomainEntity(
                ReferenceApplication.testTuteeApplication);

        // assert
        expect(assignment, isA<TuteeApplicationEntity>());
      });
    });
    group('toDomainEntity', () {
      test(
          'Should return Application<TuteeAssignment> from valid TuteeApplicationEntity',
          () {
        // act
        final Application<TuteeAssignment> result =
            ReferenceApplication.testTuteeApplicationEntity.toDomainEntity();

        // assert
        expect(result.application,
            ReferenceApplication.testTuteeApplication.application);
        expect(result.dates, ReferenceApplication.testTuteeApplication.dates);
        expect(result.status, ReferenceApplication.testTuteeApplication.status);
      });
    });
    group('fromJson', () {
      test('Should return TuteeApplicationEntity from valid json ', () {
        // act
        final TuteeApplicationEntity result = TuteeApplicationEntity.fromJson(
          json.decode(fixture('applications/tutee_application.json')),
        );

        // assert
        expect(
            result.toDomainEntity(), ReferenceApplication.testTuteeApplication);
      });
      test('Should return null when json is empty', () {
        // act
        final TuteeApplicationEntity result =
            TuteeApplicationEntity.fromJson(const <String, dynamic>{});

        // assert
        expect(result, null);
      });
    });
    group('toJson', () {
      test('Should return a JSON map containing the proper data', () {
        // act
        final Map<String, dynamic> result =
            ReferenceApplication.testTuteeApplicationEntity.toJson();
        final Map<String, dynamic> expected =
            json.decode(fixture('applications/tutee_application.json'));

        // assert
        expect(result, expected);
      });
    });
    group('Document Snapshot conversion', () {
      final Timestamp timestamp =
          Timestamp.fromMillisecondsSinceEpoch(1589382444000);

      Map<String, dynamic> testDocumentSnapshot;

      setUp(() {
        testDocumentSnapshot = <String, dynamic>{
          'info': {
            'identity': {
              'pUrl':
                  'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
              'name': {'f': 'John', 'l': 'Tan'},
              'uid': '12345',
              'accType': '.s',
              'isPblc': true,
              'isOpn': true
            },
            'details': {
              'date': {'create': timestamp, 'mod': timestamp},
              'lvl': {'Pri6': 1},
              'subj': {'Science': 1},
              'grade': {'start': 'Bnd3', 'end': null},
              'addRmrks':
                  'needs someone who is pateint and can focus on dull stuff'
            },
            'requirements': {
              'time': 'Anytime weekdays after 2pm',
              'loc': 'Singapore 123456, Jurong East Ave Blk 6',
              'rates': {'min': 0.0, 'max': 0.0, 'prop': 20.0, 'type': 'Hr'},
              'frmt': {'On': 1, 'Pr': 1},
              'freq': '1x a week',
              'gender': {'m': 1},
              'occs': {'FT': 1, 'PT': 1, 'MOE': 1}
            },
          },
          'status': 'Accept',
          'dates': {
            'req': timestamp,
            'start': timestamp,
            'end': null,
            'dec': null
          }
        };
      });

      group('fromDocumentSnapshot', () {
        test(
            'Should return TuteeApplicationEntity from valid documentSnapshot ',
            () {
          // act
          final TuteeApplicationEntity result =
              TuteeApplicationEntity.fromDocumentSnapshot(
            testDocumentSnapshot,
            'id12345',
          );

          // assert
          expect(result.toDomainEntity(),
              ReferenceApplication.testTuteeApplication);
        });
        test('Should return null when snapshot is empty', () {
          // act
          final TuteeApplicationEntity result =
              TuteeApplicationEntity.fromDocumentSnapshot(
                  const <String, dynamic>{}, '12345');

          // assert
          expect(result, null);
        });
      });
      group('toDocumentSnapshot', () {
        test('''Should return a JSON map formatted for storage in firestore
        WITH original [dateAdded] field and [dateModified] since [isNew] is false and [freeze] is true
        AND current time for ['dates']['end'] since [ApplicationDateType] is [end]''',
            () {
          // arrange
          final Map<String, dynamic> expected = <String, dynamic>{
            'info': {
              'identity': {
                'pUrl':
                    'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
                'name': {'f': 'John', 'l': 'Tan'},
                'uid': '12345',
                'accType': '.s',
                'isPblc': true,
                'isOpn': true
              },
              'details': {
                'date': {
                  'create': timestamp,
                  'mod': timestamp,
                },
                'lvl': {'Pri6': 1},
                'subj': {'Science': 1},
                'grade': {'start': 'Bnd3', 'end': null},
                'addRmrks':
                    'needs someone who is pateint and can focus on dull stuff'
              },
              'requirements': {
                'time': 'Anytime weekdays after 2pm',
                'loc': 'Singapore 123456, Jurong East Ave Blk 6',
                'rates': {'min': 0.0, 'max': 0.0, 'prop': 20.0, 'type': 'Hr'},
                'frmt': {'On': 1, 'Pr': 1},
                'freq': '1x a week',
                'gender': {'m': 1},
                'occs': {'FT': 1, 'PT': 1, 'MOE': 1}
              },
            },
            'status': 'Accept',
            'dates': {
              'req': timestamp,
              'start': timestamp,
              'end': FieldValue.serverTimestamp(),
              'dec': null
            }
          };

          // act
          final Map<String, dynamic> result = ReferenceApplication
              .testTuteeApplicationEntity
              .toDocumentSnapshot(
            isNew: false,
            freeze: true,
            dateType: ApplicationDateType.end,
          );

          // assert
          expect(result, expected);
        });
      });
    });
  });
}
