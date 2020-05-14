import 'dart:convert';
import 'package:cotor/data/models/post/tutor_profile/requirements/requirements_tutor_entity.dart';

import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../reference_profile.dart';

void main() {
  group('Requirement Tutor Entity', () {
    group('fromDomainEntity', () {
      test(
          'should return RequirementsTutorEntity when passed with valid RequirementsTutor',
          () {
        // act
        final result = RequirementsTutorEntity.fromDomainEntity(
            ReferenceProfile.testRequirementsTutor);

        // assert
        expect(result, isA<RequirementsTutorEntity>());
      });
    });

    group('toDomainEntity', () {
      test('should return RequirementsTutor', () {
        // act
        final result =
            ReferenceProfile.testRequirementsTutorEntity.toDomainEntity();

        // assert
        expect(result, isA<RequirementsTutor>());
      });
    });

    group('fromJson', () {
      test(
        '''should return a valid model when the JSON is properly formatted.
      ''',
        () async {
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('profile/profile_requirements.json'));

          // act
          final result = RequirementsTutorEntity.fromJson(jsonMap);
          // assert
          expect(
              result.toDomainEntity(), ReferenceProfile.testRequirementsTutor);
        },
      );
      test(
        '''should return null when Json is empty''',
        () async {
          // act
          final result =
              RequirementsTutorEntity.fromJson(const <String, dynamic>{});
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
          final result = RequirementsTutorEntity.fromDomainEntity(
                  ReferenceProfile.testRequirementsTutorEntity)
              .toJson();
          // assert
          final Map<String, dynamic> expectedJsonMap =
              json.decode(fixture('profile/profile_requirements.json'));
          expect(result, expectedJsonMap);
        },
      );
    });
    group('fromFirebaseMap', () {
      test(
        '''should return a valid model when the JSON is properly formatted.
      ''',
        () async {
          final Map<String, dynamic> jsonMap = json
              .decode(fixture('profile/profile_requirements_firebase.json'));

          // act
          final result = RequirementsTutorEntity.fromFirebaseMap(jsonMap);
          // assert
          expect(
              result.toDomainEntity(), ReferenceProfile.testRequirementsTutor);
        },
      );
      test(
        '''should return null when Json is empty''',
        () async {
          // act
          final result = RequirementsTutorEntity.fromFirebaseMap(
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
          final result = RequirementsTutorEntity.fromDomainEntity(
                  ReferenceProfile.testRequirementsTutorEntity)
              .toFirebaseMap();
          // assert
          final Map<String, dynamic> expectedJsonMap = json
              .decode(fixture('profile/profile_requirements_firebase.json'));
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
