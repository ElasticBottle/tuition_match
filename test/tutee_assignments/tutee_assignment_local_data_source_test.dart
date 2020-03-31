import 'dart:convert';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/models/criteria_params.dart';
import 'package:cotor/features/tutee_assignments/data/models/subject_model.dart';
import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

const String TUTEE_ASSIGNMENT_LIST = 'tuteeAssignmentList.txt';
void main() {
  TuteeAssignmentLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = TuteeAssignmentLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  final List<dynamic> assignmentString =
      json.decode(fixture(TUTEE_ASSIGNMENT_LIST));
  print(assignmentString[0].runtimeType);
  final List<TuteeAssignmentModel> tTuteeAssignmentModelList = assignmentString
      .map((dynamic e) => TuteeAssignmentModel.fromJson(e))
      .toList();
  group('getLastAssignmentList', () {
    test(
      'should return TuteeAssignmentModel in List from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture(TUTEE_ASSIGNMENT_LIST));
        // act
        final result = await dataSource.getLastAssignmentList();
        // assert
        verify(mockSharedPreferences.getString('CACHED_ASSIGNMENT_LIST'));
        expect(result, equals(tTuteeAssignmentModelList));
      },
    );
    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      // Not calling the method here, just storing it inside a call variable
      final call = dataSource.getLastAssignmentList;
      // assert
      // Calling the method happens from a higher-order function passed.
      // This is needed to test if calling a method throws an exception.
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheAssignmentList', () {
    test('should call SharedPreferences to cache the data', () {
      // act
      dataSource.cacheAssignmentList(tTuteeAssignmentModelList);
      // assert
      final List<Map<String, dynamic>> toEncode = tTuteeAssignmentModelList
          .map((TuteeAssignmentModel e) => e.toJson())
          .toList();
      final expectedJsonString = json.encode(toEncode);
      verify(mockSharedPreferences.setString(
        CACHED_ASSIGNMENT_LIST,
        expectedJsonString,
      ));
    });
  });

  group('cacheToExistingAssignmentList', () {
    test(
      'should call SharedPreferences',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture(TUTEE_ASSIGNMENT_LIST));
        // act
        await dataSource.getLastAssignmentList();
        // assert
        verify(mockSharedPreferences.getString('CACHED_ASSIGNMENT_LIST'));
      },
    );
    test('should call SharedPreferences to cache the data', () {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture(TUTEE_ASSIGNMENT_LIST));

      // act
      dataSource.cacheAssignmentList(tTuteeAssignmentModelList);
      // assert
      final List<Map<String, dynamic>> toEncode = tTuteeAssignmentModelList
          .map((TuteeAssignmentModel e) => e.toJson())
          .toList();
      final expectedJsonString = json.encode(toEncode);
      verify(mockSharedPreferences.setString(
        CACHED_ASSIGNMENT_LIST,
        expectedJsonString,
      ));
    });
  });

  group('cacheParams', () {
    final tLevelSearch = Level.values[2];
    final tSubjectSearch =
        SubjectModel(level: Level.values[2], sbjArea: 'science');
    const double tRateMin = 60.0;
    const double tRateMax = 80.0;
    final tCriteriaParam = CriteriaParams(
      level: tLevelSearch,
      subject: tSubjectSearch,
      rateMax: tRateMax,
      rateMin: tRateMin,
    );
    test('should call SharedPreferences to cache the data', () {
      // act
      dataSource.cacheCriterion(tCriteriaParam);
      // assert
      verify(mockSharedPreferences.setString(
          'CACHED_CRITERION',
          json.encode([
            tLevelSearch.index.toString(),
            tSubjectSearch.level.index.toString(),
            tSubjectSearch.subjectArea,
            tRateMin.toString(),
            tRateMax.toString()
          ])));
    });
  });

  group('getCachedParams', () {
    final tLevelSearch = Level.values[2];
    final tSubjectSearch =
        Subject(level: Level.values[2], subjectArea: 'science');
    const double tRateMin = 60.0;
    const double tRateMax = 80.0;
    test(
      'should return Params from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        final String toReturn =
            '["${tLevelSearch.index.toString()}","${tSubjectSearch.level.index.toString()}","${tSubjectSearch.subjectArea}","${tRateMin.toString()}","${tRateMax.toString()}"]';
        when(mockSharedPreferences.getString(any)).thenReturn(toReturn);
        // act
        final result = await dataSource.getCachedParams();
        // assert
        verify(mockSharedPreferences.getString('CACHED_CRITERION'));
        expect(
            result.props,
            equals(CriteriaParams(
              level: tLevelSearch,
              subject: tSubjectSearch,
              rateMax: tRateMax,
              rateMin: tRateMin,
            ).props));
      },
    );
    test('should throw a CacheException when there is not a cached value', () {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      // Not calling the method here, just storing it inside a call variable
      final call = dataSource.getCachedParams;
      // assert
      // Calling the method happens from a higher-order function passed.
      // This is needed to test if calling a method throws an exception.
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });
}
