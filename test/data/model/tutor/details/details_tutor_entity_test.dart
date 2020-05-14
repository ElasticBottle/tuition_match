import 'dart:convert';

import 'package:cotor/data/models/post/tutor_profile/details/details_tutor_entity.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../reference_profile.dart';

void main() {
  group('DetailsTutorEntity', () {
    // arrange

    group('fromDomainEntity', () {
      test(
          'should return DetailsTutorEntity when passed with valid DetailsTutor',
          () {
        // act
        final result = DetailsTutorEntity.fromDomainEntity(
            ReferenceProfile.testDetailsTutor);

        // assert
        expect(result, isA<DetailsTutorEntity>());
      });
    });

    group('toDomainEntity', () {
      test('should return DetailsTutor', () {
        // act
        final result = ReferenceProfile.testDetailsTutorEntity.toDomainEntity();

        // assert
        expect(result, isA<DetailsTutor>());
      });
    });
    group('fromJson', () {
      test(
        '''should return a valid model when the JSON is properly formatted.
      ''',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('profile/profile_details.json'));
          // act
          final result = DetailsTutorEntity.fromJson(jsonMap);
          // assert
          expect(result.toDomainEntity(), ReferenceProfile.testDetailsTutor);
        },
      );
      test(
        '''should return null when Json is empty''',
        () async {
          // act
          final result = DetailsTutorEntity.fromJson(const <String, dynamic>{});
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
          final result = DetailsTutorEntity.fromDomainEntity(
                  ReferenceProfile.testDetailsTutor)
              .toJson();
          // assert
          final Map<String, dynamic> expectedJsonMap =
              json.decode(fixture('profile/profile_details.json'));
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
