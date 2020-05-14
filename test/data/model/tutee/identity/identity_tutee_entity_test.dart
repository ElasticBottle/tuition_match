import 'dart:convert';

import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/tutee_assignment/indentity/identity_tutee_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../reference_assignment.dart';

void main() {
  group('IdentityTuteeEntity', () {
    group('fromDomainEntity', () {
      test(
          'should return IdentityTuteeEntity when passed with valid IdentityTutee',
          () {
        // act
        final result = IdentityTuteeEntity.fromDomainEntity(
            ReferenceAssignment.testIdentityTutee);

        // assert
        expect(result, isA<IdentityTuteeEntity>());
      });
    });

    group('toDomainEntity', () {
      test('should return IdentityTutee', () {
        // act
        final result =
            ReferenceAssignment.testIdentityTuteeEntity.toDomainEntity();

        // assert
        expect(result, isA<IdentityTutee>());
      });
    });

    group('fromJson', () {
      test(
        '''should return a valid model when the JSON is properly formatted.
      ''',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap = json
              .decode(fixture('assignment/assignment_identity_firebase.json'));
          jsonMap[POST_ID] = 'id12345';

          // act
          final result = IdentityTuteeEntity.fromJson(jsonMap);
          // assert
          expect(
              result.toDomainEntity(), ReferenceAssignment.testIdentityTutee);
        },
      );
      test(
        '''should return null when Json is empty''',
        () async {
          // act
          final result =
              IdentityTuteeEntity.fromJson(const <String, dynamic>{});
          // assert
          expect(result, null);
        },
      );
    });
    group('toFirebaseMap', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = IdentityTuteeEntity.fromDomainEntity(
                  ReferenceAssignment.testIdentityTutee)
              .toFirebaseMap();
          // assert
          final Map<String, dynamic> expectedJsonMap = json
              .decode(fixture('assignment/assignment_identity_firebase.json'));
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
