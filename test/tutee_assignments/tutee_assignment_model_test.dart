import 'dart:convert';

import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final tTuteeAssignmentModel = TuteeAssignmentModel();

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tTuteeAssignmentModel, isA<TuteeAssignment>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        final result = TuteeAssignmentModel.fromJson(jsonMap);
        // assert
        expect(result, tTuteeAssignmentModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tTuteeAssignmentModel.toJson();
        // assert
        final expectedJsonMap = <String, dynamic>{};
        expect(result, expectedJsonMap);
      },
    );
  });
}
