import 'dart:convert';

import 'package:cotor/data/models/post/tutee_assignment/requirements/requirements_tutee_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/requirements/requirements_tutee.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../reference_assignment.dart';

void main() {
  group('Requirement Tutor Entity', () {
    group('fromDomainEntity', () {
      test(
          'should return RequirementsTuteeEntity when passed with valid RequirementsTutee',
          () {
        // act
        final result = RequirementsTuteeEntity.fromDomainEntity(
            ReferenceAssignment.testRequirementsTutee);

        // assert
        expect(result, isA<RequirementsTuteeEntity>());
      });
    });

    group('toDomainEntity', () {
      test('should return RequirementsTutee', () {
        // act
        final result =
            ReferenceAssignment.testRequirementsTuteeEntity.toDomainEntity();

        // assert
        expect(result, isA<RequirementsTutee>());
      });
    });

    group('fromJson', () {
      test(
        '''should return a valid model when the JSON is properly formatted.
      ''',
        () async {
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('assignment/assignment_requirements.json'));

          // act
          final result = RequirementsTuteeEntity.fromJson(jsonMap);
          // assert
          expect(result.toDomainEntity(),
              ReferenceAssignment.testRequirementsTutee);
        },
      );
      test(
        '''should return null when Json is empty''',
        () async {
          // act
          final result =
              RequirementsTuteeEntity.fromJson(const <String, dynamic>{});
          // assert
          expect(result, null);
        },
      );
    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // act
          final result = RequirementsTuteeEntity.fromDomainEntity(
                  ReferenceAssignment.testRequirementsTuteeEntity)
              .toJson();
          // assert
          final Map<String, dynamic> expectedJsonMap =
              json.decode(fixture('assignment/assignment_requirements.json'));
          expect(result, expectedJsonMap);
        },
      );
    });
    group('fromFirebaseMap', () {
      test(
        '''should return a valid model when the JSON is properly formatted.
      ''',
        () async {
          final Map<String, dynamic> jsonMap = json.decode(
              fixture('assignment/assignment_requirements_firebase.json'));

          // act
          final result = RequirementsTuteeEntity.fromFirebaseMap(jsonMap);
          // assert
          expect(result.toDomainEntity(),
              ReferenceAssignment.testRequirementsTutee);
        },
      );
      test(
        '''should return null when Json is empty''',
        () async {
          // act
          final result = RequirementsTuteeEntity.fromFirebaseMap(
              const <String, dynamic>{});
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
          final result = RequirementsTuteeEntity.fromDomainEntity(
                  ReferenceAssignment.testRequirementsTuteeEntity)
              .toFirebaseMap();
          // assert
          final Map<String, dynamic> expectedJsonMap = json.decode(
              fixture('assignment/assignment_requirements_firebase.json'));
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
