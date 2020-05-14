import 'dart:convert';

import 'package:cotor/data/models/post/tutee_assignment/details/detail_tutee_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/details/details_tutee.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../reference_assignment.dart';

void main() {
  group('DetailsTuteeEntity', () {
    // arrange

    group('fromDomainEntity', () {
      test(
          'should return DetailsTuteeEntity when passed with valid DetailsTutee',
          () {
        // act
        final result = DetailsTuteeEntity.fromDomainEntity(
            ReferenceAssignment.testDetailsTutee);

        // assert
        expect(result, isA<DetailsTuteeEntity>());
      });
    });

    group('toDomainEntity', () {
      test('should return DetailsTutee', () {
        // act
        final result =
            ReferenceAssignment.testDetailsTuteeEntity.toDomainEntity();

        // assert
        expect(result, isA<DetailsTutee>());
      });
    });
    group('fromJson', () {
      test(
        '''should return a valid model when the JSON is properly formatted.
      ''',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('assignment/assignment_details.json'));
          // act
          final result = DetailsTuteeEntity.fromJson(jsonMap);
          // assert
          expect(result.toDomainEntity(), ReferenceAssignment.testDetailsTutee);
        },
      );
      test(
        '''should return null when Json is empty''',
        () async {
          // act
          final result = DetailsTuteeEntity.fromJson(const <String, dynamic>{});
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
          final result = DetailsTuteeEntity.fromDomainEntity(
                  ReferenceAssignment.testDetailsTutee)
              .toJson();
          // assert
          final Map<String, dynamic> expectedJsonMap =
              json.decode(fixture('assignment/assignment_details.json'));
          expect(result, expectedJsonMap);
        },
      );
    });
  });
}
