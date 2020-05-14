import 'dart:convert';

import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/user/identity_user_entity.dart';
import 'package:cotor/domain/entities/user/user_export.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';
import 'reference_user.dart';

void main() {
  group('fromDomainEntity', () {
    test('should return IdentityUserEntity when passed with valid UserIdentity',
        () {
      // act
      final result =
          IdentityUserEntity.fromDomainEntity(ReferenceUser.testIdentityUser);

      // assert
      expect(result, isA<IdentityUserEntity>());
    });
  });

  group('toDomainEntity', () {
    test('should return IdentityUser', () {
      // act
      final result = ReferenceUser.testIdentityUserEntity.toDomainEntity();

      // assert
      expect(result, isA<IdentityUser>());
    });
  });
  group('fromJson', () {
    test(
      '''should return a valid model when the JSON is properly formatted.
      WITH string for [photoUrl],
      Map<String, String> for [name]
      String for [accountType]
      boolean for [isVerifiedAccount]''',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('user/user_identity.json'));
        jsonMap[UID] = '12345';
        // act
        final result = IdentityUserEntity.fromJson(jsonMap);
        // assert
        expect(result.toDomainEntity(), ReferenceUser.testIdentityUser);
      },
    );
    test(
      '''should return null when Json is empty''',
      () async {
        // act
        final result = IdentityUserEntity.fromJson(const <String, dynamic>{});
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
        final result = ReferenceUser.testIdentityUserEntity.toFirebaesMap();
        // assert
        final Map<String, dynamic> expectedJsonMap =
            json.decode(fixture('user/user_identity.json'));
        expect(result, expectedJsonMap);
      },
    );
  });
}
