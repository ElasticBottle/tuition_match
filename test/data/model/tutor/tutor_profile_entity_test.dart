import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/post/tutor_profile/tutor_profile_entity.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';
import 'reference_profile.dart';

void main() {
  group('tutorProfileEntity', () {
    group('fromDomainEntity', () {
      test('Should return TutorProfileEntity from valid TutorProfile', () {
        // act
        final TutorProfileEntity profile =
            TutorProfileEntity.fromDomainEntity(ReferenceProfile.testProfile);

        // assert
        expect(profile, isA<TutorProfileEntity>());
      });
    });
    group('toDomainEntity', () {
      test('Should return TutorProfile from valid TutorProfileEntity', () {
        // act
        final TutorProfile result =
            ReferenceProfile.testProfileEntity.toDomainEntity();

        // assert
        expect(result, ReferenceProfile.testProfile);
      });
    });
    group('fromJson', () {
      test('Should return TutorProfileEntity from valid json ', () {
        // act
        final TutorProfileEntity result = TutorProfileEntity.fromJson(
          json.decode(fixture('profile/profile.json')),
        );

        // assert
        expect(result.toDomainEntity(), ReferenceProfile.testProfile);
      });
      test('Should return null when json is empty', () {
        // act
        final TutorProfileEntity result =
            TutorProfileEntity.fromJson(const <String, dynamic>{});

        // assert
        expect(result, null);
      });
    });
    group('toJson', () {
      test('Should return a JSON map containing the proper data', () {
        // act
        final Map<String, dynamic> result =
            ReferenceProfile.testProfileEntity.toJson();
        final Map<String, dynamic> expected =
            json.decode(fixture('profile/profile.json'));

        // assert
        expect(result, expected);
      });
    });
    group('Document Snapshot conversion', () {
      final Timestamp timestamp =
          Timestamp.fromMillisecondsSinceEpoch(1589382444000);

      final Map<String, dynamic> testDocumentSnapshot = <String, dynamic>{
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
        },
        'stats': {'like': 5, 'request': 3}
      };
      group('fromDocumentSnapshot', () {
        test('Should return TutorProfileEntity from valid documentSnapshot ',
            () {
          // act
          final TutorProfileEntity result =
              TutorProfileEntity.fromDocumentSnapshot(
            testDocumentSnapshot,
            uid: '12345',
          );

          // assert
          expect(result.toDomainEntity(), ReferenceProfile.testProfile);
        });
        test('Should return null when snapshot is empty', () {
          // act
          final TutorProfileEntity result =
              TutorProfileEntity.fromDocumentSnapshot(const <String, dynamic>{},
                  uid: '12345');

          // assert
          expect(result, null);
        });
      });
      group('toDocumentSnapshot', () {
        test('''Should return a JSON map formatted for storage in firestore
        WITH original [dateAdded] field and new value for [dateModified] since [isNew] is false''',
            () {
          // arrange
          final Map<String, dynamic> expectedDocumentSnapshot =
              <String, dynamic>{
            'identity': {
              'pUrl':
                  'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
              'name': {'f': 'John', 'l': 'Tan'},
              'accType': '.t',
              'isOpn': true,
              'gender': 'm'
            },
            'details': {
              'date': {
                'create': timestamp,
                'mod': FieldValue.serverTimestamp()
              },
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
            },
            'stats': {'like': FieldValue, 'request': FieldValue}
          };
          // act
          final Map<String, dynamic> result = ReferenceProfile.testProfileEntity
              .toDocumentSnapshot(isNew: false);

          // assert
          expect(result, expectedDocumentSnapshot);
        });
        test('''Should return a JSON map formatted for storage in firestore
        WITH new [dateAdded] and [dateModified] since [isNew] is true''', () {
          // arrange
          final Map<String, dynamic> expectedDocumentSnapshot =
              <String, dynamic>{
            'identity': {
              'pUrl':
                  'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
              'name': {'f': 'John', 'l': 'Tan'},
              'accType': '.t',
              'isOpn': true,
              'gender': 'm'
            },
            'details': {
              'date': {
                'create': FieldValue.serverTimestamp(),
                'mod': FieldValue.serverTimestamp()
              },
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
            },
            'stats': {'like': 0, 'request': 0}
          };
          // act
          final Map<String, dynamic> result = ReferenceProfile.testProfileEntity
              .toDocumentSnapshot(isNew: true);

          // assert
          expect(result, expectedDocumentSnapshot);
        });
      });
    });
  });
}
