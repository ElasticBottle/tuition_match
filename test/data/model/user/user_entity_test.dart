import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/data/models/user/user_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:cotor/domain/entities/user/user_export.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';
import 'reference_user.dart';

void main() {
  group('UserEntity', () {
    group('fromDomainEntity', () {
      test('Should return UserEntity from valid User', () {
        // act
        final UserEntity profile =
            UserEntity.fromDomainEntity(ReferenceUser.testUser);

        // assert
        expect(profile, isA<UserEntity>());
      });
    });
    group('toDomainEntity', () {
      test('Should return User from valid UserEntity', () {
        // act
        final User result = ReferenceUser.testUserEntity.toDomainEntity();

        // assert
        expect(result, ReferenceUser.testUser);
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
          'accType': '.b'
        },
        'assgnmnts': {
          'id12345': {
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
            'stats': {'like': 5, 'request': 3}
          }
        },
        'profile': {
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
            'occ': 'Part Time',
            'quali': 'Top scorer',
            'sellPts': 'Three previous tutess, all scored failing grades'
          },
          'requirements': {
            'time': 'Anytime weekdays after 2pm',
            'loc': 'Anywhere in the East, prefereably near Ang Mo Kio',
            'rates': {'min': 10.0, 'max': 30.0, 'prop': 0.0, 'type': 'Hr'},
            'frmt': {'Online': 1, 'Private': 1}
          },
          'stats': {'like': 5, 'request': 3}
        }
      };
      group('fromDocumentSnapshot', () {
        test(
            'Should return UserEntity from valid documentSnapshot with assginments and profile',
            () {
          // act
          final UserEntity result = UserEntity.fromDocumentSnapshot(
            testDocumentSnapshot,
            '12345',
          );

          // assert
          expect(result.toDomainEntity(), ReferenceUser.testUser);
        });
        test(
            'Should return UserEntity from valid documentSnapshot with assginments and no profile',
            () {
          // arrange
          testDocumentSnapshot[USER_PROFILE] = <String, dynamic>{};
          final User expected = User(
            assignments: ReferenceUser.testUser.assignments,
            identity: ReferenceUser.testUser.identity,
          );
          print(expected);

          // act
          final UserEntity result = UserEntity.fromDocumentSnapshot(
            testDocumentSnapshot,
            '12345',
          );

          // assert
          expect(result.toDomainEntity(), expected);
        });
        test(
            'Should return UserEntity from valid documentSnapshot with no assginments and no profile',
            () {
          // arrange
          testDocumentSnapshot[USER_PROFILE] = <String, dynamic>{};
          testDocumentSnapshot[USER_ASSIGNMENTS] = <String, dynamic>{};

          final User expected = User(
            identity: ReferenceUser.testUser.identity,
            assignments: const <String, TuteeAssignment>{},
          );

          // act
          final UserEntity result = UserEntity.fromDocumentSnapshot(
            testDocumentSnapshot,
            '12345',
          );

          // assert
          expect(result.toDomainEntity(), expected);
        });
        test('Should return null when snapshot is empty', () {
          // act
          final UserEntity result = UserEntity.fromDocumentSnapshot(
              const <String, dynamic>{}, '12345');

          // assert
          expect(result, null);
        });
      });

      group('toDocumentSnapshot', () {
        Map<String, dynamic> expectedDocumentSnapshot;
        setUp(() {
          expectedDocumentSnapshot = <String, dynamic>{
            'identity': {
              'pUrl':
                  'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
              'name': {'f': 'John', 'l': 'Tan'},
              'accType': '.b'
            },
            'assgnmnts': {
              'id12345': {
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
                'stats': {'like': FieldValue, 'request': FieldValue}
              }
            },
            'profile': {
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
              'stats': {'like': FieldValue, 'request': FieldValue}
            }
          };
        });

        test('''Should return a map formatted for storage in firestore''', () {
          // act
          final Map<String, dynamic> result =
              ReferenceUser.testUserEntity.toDocumentSnapshot();

          // assert
          expect(result, expectedDocumentSnapshot);
        });
        test('''Should return a map formatted for storage in firestore
        WITH empty map under [USER_ASSIGNMENTS] if user has no assignments''',
            () {
          // arrange
          final UserEntity testCase = UserEntity(
            identity: ReferenceUser.testUserEntity.identity,
            assignments: const <String, TuteeAssignmentEntity>{},
            profile: ReferenceUser.testUserEntity.profile,
          );

          final Map<String, dynamic> expected = expectedDocumentSnapshot;
          expected[USER_ASSIGNMENTS] = <String, dynamic>{};
          // act
          final Map<String, dynamic> result = testCase.toDocumentSnapshot();

          // assert
          expect(result, expected);
        });
        test('''Should return a map formatted for storage in firestore
        WITH null under [USER_PROFILE] if user has no profile''', () {
          // arrange
          final UserEntity testCase = UserEntity(
            identity: ReferenceUser.testUserEntity.identity,
            assignments: ReferenceUser.testUserEntity.assignments,
          );

          final Map<String, dynamic> expected = expectedDocumentSnapshot;
          expected[USER_PROFILE] = null;
          // act
          final Map<String, dynamic> result = testCase.toDocumentSnapshot();

          // assert
          expect(result, expected);
        });
      });
    });
  });
}
