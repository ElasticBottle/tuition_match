import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/data/models/post/applications/tutor_application/tutor_application_entity.dart';
import 'package:cotor/domain/entities/post/applications/application.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../reference_application.dart';

void main() {
  group('TutorApplicationEntity', () {
    group('fromDomainEntity', () {
      test(
          'Should return TutorApplicationEntity from valid Application<TutorProfile>',
          () {
        // act
        final TutorApplicationEntity assignment =
            TutorApplicationEntity.fromDomainEntity(
                ReferenceApplication.testTutorApplication);

        // assert
        expect(assignment, isA<TutorApplicationEntity>());
      });
    });
    group('toDomainEntity', () {
      test(
          'Should return Application<TutorProfile> from valid TutorApplicationEntity',
          () {
        // act
        final Application<TutorProfile> result =
            ReferenceApplication.testTutorApplicationEntity.toDomainEntity();

        // assert
        expect(result, ReferenceApplication.testTutorApplication);
      });
    });
    group('fromJson', () {
      test('Should return TutorApplicationEntity from valid json ', () {
        // act
        final TutorApplicationEntity result = TutorApplicationEntity.fromJson(
          json.decode(fixture('applications/tutor_application.json')),
        );

        // assert
        expect(
            result.toDomainEntity(), ReferenceApplication.testTutorApplication);
      });
      test('Should return null when json is empty', () {
        // act
        final TutorApplicationEntity result =
            TutorApplicationEntity.fromJson(const <String, dynamic>{});

        // assert
        expect(result, null);
      });
    });
    group('toJson', () {
      test('Should return a JSON map containing the proper data', () {
        // act
        final Map<String, dynamic> result =
            ReferenceApplication.testTutorApplicationEntity.toJson();
        final Map<String, dynamic> expected =
            json.decode(fixture('applications/tutor_application.json'));

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
              'accType': '.t',
              'isOpn': true,
              'gender': 'm'
            },
            'details': {
              'date': {'create': timestamp, 'mod': timestamp},
              'lvlTeach': {'Pri6': 1, 'Pri5': 1},
              'sbjTeach': {'Science': 1, 'Math': 1},
              'occ': 'PT',
              'quali': 'Top scorer',
              'sellPts': 'Three previous tutess, all scored failing grades'
            },
            'requirements': {
              'time': 'Anytime weekdays after 2pm',
              'loc': 'Anywhere in the East, prefereably near Ang Mo Kio',
              'rates': {'min': 10.0, 'max': 30.0, 'prop': 0.0, 'type': 'Hr'},
              'frmt': {'On': 1, 'Pr': 1}
            }
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
            'Should return TutorApplicationEntity from valid documentSnapshot ',
            () {
          // act
          final TutorApplicationEntity result =
              TutorApplicationEntity.fromDocumentSnapshot(
            testDocumentSnapshot,
            '12345',
          );

          // assert
          expect(result.toDomainEntity(),
              ReferenceApplication.testTutorApplication);
        });
        test('Should return null when snapshot is empty', () {
          // act
          final TutorApplicationEntity result =
              TutorApplicationEntity.fromDocumentSnapshot(
                  const <String, dynamic>{}, '12345');

          // assert
          expect(result, null);
        });
      });
      group('toDocumentSnapshot', () {
        // TODO(EB): make toDocumentSnapshot tests more comprehensive
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
                'accType': '.t',
                'isOpn': true,
                'gender': 'm'
              },
              'details': {
                'date': {'create': timestamp, 'mod': timestamp},
                'lvlTeach': {'Pri6': 1, 'Pri5': 1},
                'sbjTeach': {'Science': 1, 'Math': 1},
                'occ': 'PT',
                'quali': 'Top scorer',
                'sellPts': 'Three previous tutess, all scored failing grades'
              },
              'requirements': {
                'time': 'Anytime weekdays after 2pm',
                'loc': 'Anywhere in the East, prefereably near Ang Mo Kio',
                'rates': {'min': 10.0, 'max': 30.0, 'prop': 0.0, 'type': 'Hr'},
                'frmt': {'On': 1, 'Pr': 1}
              }
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
              .testTutorApplicationEntity
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
