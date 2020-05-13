import 'dart:convert';

import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/tutor_profile/identity/identity_tutors_entity.dart';

import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../reference_profile.dart';

void main() {
  group('IdentityTutorEntity', () {
    // arrange

    group('fromDomainEntity', () {
      test(
          'should return IdentityTutorEntity when passed with valid IdentityTutor',
          () {
        // act
        final result = IdentityTutorEntity.fromDomainEntity(
            ReferenceProfile.testIdentityTutor);

        // assert
        expect(result, isA<IdentityTutorEntity>());
      });
    });

    group('toDomainEntity', () {
      test('should return IdentityTutor', () {
        // act
        final result =
            ReferenceProfile.testIdentityTutorEntity.toDomainEntity();

        // assert
        expect(result, isA<IdentityTutor>());
      });
    });

    group('fromJson', () {
      test(
        '''should return a valid model when the JSON is properly formatted.
      ''',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('profile/profile_identity_firebase.json'));
          jsonMap[UID] = '12345';

          // act
          final result = IdentityTutorEntity.fromJson(jsonMap);
          // assert
          expect(result.toDomainEntity(), ReferenceProfile.testIdentityTutor);
        },
      );
      test(
        '''should return null when Json is empty''',
        () async {
          // act
          final result =
              IdentityTutorEntity.fromJson(const <String, dynamic>{});
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
          final result = IdentityTutorEntity.fromDomainEntity(
                  ReferenceProfile.testIdentityTutor)
              .toFirebaseMap();
          // assert
          final Map<String, dynamic> expectedJsonMap =
              json.decode(fixture('profile/profile_identity_firebase.json'));
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
