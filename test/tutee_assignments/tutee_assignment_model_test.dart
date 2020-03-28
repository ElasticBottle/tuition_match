import 'dart:convert';

import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final tTuteeAssignmentModel = TuteeAssignmentModel(
    postId: 'postId',
    additionalRemarks: 'addtionalRemarks',
    applied: 1,
    format: ClassFormat.values[1],
    gender: Gender.values[1],
    level: Level.values[2],
    subjectModel: SubjectModel(level: Level.values[2], sbjArea: 'science'),
    timing: 'timing',
    rateMax: 80.0,
    rateMin: 60.0,
    location: 'location',
    freq: 'freq',
    tutorOccupation: TutorOccupation.values[0],
    status: Status.values[0],
    username: 'username',
    tuteeNameModel: NameModel(firstName: 'john', lastName: 'doe'),
    liked: const ['username1', 'username2'],
  );

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tTuteeAssignmentModel, isA<TuteeAssignment>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model from JSON',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('tuteeAssignment.txt'));
        // act
        final result = TuteeAssignmentModel.fromJson(jsonMap);
        // assert
        expect(result, isA<TuteeAssignment>());
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
        final expectedJsonMap = <String, dynamic>{
          'postId': {
            'level': 2,
            'subject': {'level': 2, 'subjectArea': 'science'},
            'timing': 'timing',
            'location': 'location',
            'rateMin': 60.0,
            'rateMax': 80.0,
            'gender': 1,
            'freq': 'freq',
            'tutorOccupation': 0,
            'format': 1,
            'additionalRemarks': 'addtionalRemarks',
            'applied': 1,
            'liked': ['username1', 'username2'],
            'status': 0,
            'username': 'username',
            'tuteeName': {'firstName': 'john', 'lastName': 'doe'}
          }
        };
        expect(result, expectedJsonMap);
      },
    );
  });
}
