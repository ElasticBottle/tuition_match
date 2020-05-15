import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';
import 'reference_assignment.dart';

void main() {
  group('TuteeAssignmentEntity', () {
    group('fromDomainEntity', () {
      test('Should return TuteeAssignmentEntity from valid TuteeAssignment',
          () {
        // act
        final TuteeAssignmentEntity assignment =
            TuteeAssignmentEntity.fromDomainEntity(
                ReferenceAssignment.testAssignment);

        // assert
        expect(assignment, isA<TuteeAssignmentEntity>());
      });
    });
    group('toDomainEntity', () {
      test('Should return TuteeAssignment from valid TuteeAssignmentEntity',
          () {
        // act
        final TuteeAssignment result =
            ReferenceAssignment.testAssignmentEntity.toDomainEntity();

        // assert
        expect(result, ReferenceAssignment.testAssignment);
      });
    });
    group('fromJson', () {
      test('Should return TuteeAssignmentEntity from valid json ', () {
        // act
        final TuteeAssignmentEntity result = TuteeAssignmentEntity.fromJson(
          json.decode(fixture('assignment/assignment.json')),
        );

        // assert
        expect(result.toDomainEntity(), ReferenceAssignment.testAssignment);
      });
      test('Should return null when json is empty', () {
        // act
        final TuteeAssignmentEntity result =
            TuteeAssignmentEntity.fromJson(const <String, dynamic>{});

        // assert
        expect(result, null);
      });
    });
    group('toJson', () {
      test('Should return a JSON map containing the proper data', () {
        // act
        final Map<String, dynamic> result =
            ReferenceAssignment.testAssignmentEntity.toJson();
        final Map<String, dynamic> expected =
            json.decode(fixture('assignment/assignment.json'));

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
          'addRmrks': 'needs someone who is pateint and can focus on dull stuff'
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
      };
      group('fromDocumentSnapshot', () {
        test('Should return TuteeAssignmentEntity from valid documentSnapshot ',
            () {
          // act
          final TuteeAssignmentEntity result =
              TuteeAssignmentEntity.fromDocumentSnapshot(
            testDocumentSnapshot,
            postId: 'id12345',
          );

          // assert
          expect(result.toDomainEntity(), ReferenceAssignment.testAssignment);
        });
        test('Should return null when snapshot is empty', () {
          // act
          final TuteeAssignmentEntity result =
              TuteeAssignmentEntity.fromDocumentSnapshot(
                  const <String, dynamic>{},
                  postId: '12345');

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
              'uid': '12345',
              'accType': '.s',
              'isPblc': true,
              'isOpn': true
            },
            'details': {
              'date': {
                'create': timestamp,
                'mod': FieldValue.serverTimestamp()
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
            'stats': {'like': FieldValue, 'request': FieldValue}
          };
          // act
          final Map<String, dynamic> result = ReferenceAssignment
              .testAssignmentEntity
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
              'uid': '12345',
              'accType': '.s',
              'isPblc': true,
              'isOpn': true
            },
            'details': {
              'date': {
                'create': FieldValue.serverTimestamp(),
                'mod': FieldValue.serverTimestamp()
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
            'stats': {'like': 0, 'request': 0}
          };

          // act
          final Map<String, dynamic> result = ReferenceAssignment
              .testAssignmentEntity
              .toDocumentSnapshot(isNew: true);

          // assert
          expect(result, expectedDocumentSnapshot);
        });
      });
    });
  });
}
