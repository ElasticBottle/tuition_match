import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/data/repositories/tutee_assignment_repository_impl.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements TuteeAssignmentRemoteDataSource {}

class MockLocalDataSource extends Mock
    implements TuteeAssignmentLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  TuteeAssignmentRepoImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TuteeAssignmentRepoImpl(
      remoteDs: mockRemoteDataSource,
      localDs: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getAssignmentListByCriterion', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final tLevelSearch = Level.values[2];
    final tSubjectSearch =
        SubjectModel(level: Level.values[2], sbjArea: 'science');
    const double tRateMin = 60.0;
    const double tRateMax = 80.0;

    final TuteeAssignmentModel tTuteeAssignmentModel = TuteeAssignmentModel(
      postId: 'postId',
      additionalRemarks: 'addtionalRemarks',
      applied: 1,
      format: ClassFormat.values[1],
      gender: Gender.values[1],
      level: tLevelSearch,
      subjectModel: tSubjectSearch,
      timing: 'timing',
      rateMax: tRateMax,
      rateMin: tRateMin,
      location: 'location',
      freq: 'freq',
      tutorOccupation: TutorOccupation.values[0],
      status: Status.values[0],
      username: 'username',
      tuteeNameModel: NameModel(firstName: 'john', lastName: 'doe'),
      liked: const ['username1', 'username2'],
    );
    final TuteeAssignment tTuteeAssignment = tTuteeAssignmentModel;

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getByCriterion(
          level: tLevelSearch,
          subject: tSubjectSearch,
          rateMax: tRateMax,
          rateMin: tRateMin);
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      // This setUp applies only to the 'device is online' group
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      void _setUpRemoteDs() {
        when(mockRemoteDataSource.getAssignmentByCriterion(
                level: tLevelSearch,
                subject: tSubjectSearch,
                rateMax: tRateMax,
                rateMin: tRateMin))
            .thenAnswer((_) async => [tTuteeAssignmentModel]);
      }

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          _setUpRemoteDs();
          // act
          final result = await repository.getByCriterion(
              level: tLevelSearch,
              subject: tSubjectSearch,
              rateMax: tRateMax,
              rateMin: tRateMin);
          // assert
          verify(mockRemoteDataSource.getAssignmentByCriterion(
              level: tLevelSearch,
              subject: tSubjectSearch,
              rateMax: tRateMax,
              rateMin: tRateMin));

          final actual = result.fold((l) => null, (r) => r[0].props);
          final expected =
              Right<Failure, List<TuteeAssignment>>([tTuteeAssignment])
                  .fold((l) => null, (r) => r[0].props);
          expect(actual, equals(expected));
        },
      );
      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          _setUpRemoteDs();
          // act
          await repository.getByCriterion(
              level: tLevelSearch,
              subject: tSubjectSearch,
              rateMax: tRateMax,
              rateMin: tRateMin);
          // assert
          verify(mockRemoteDataSource.getAssignmentByCriterion(
              level: tLevelSearch,
              subject: tSubjectSearch,
              rateMax: tRateMax,
              rateMin: tRateMin));
          verify(mockLocalDataSource.cacheAssignmentList([tTuteeAssignment]));
        },
      );
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getAssignmentByCriterion(
                  level: tLevelSearch,
                  subject: tSubjectSearch,
                  rateMax: tRateMax,
                  rateMin: tRateMin))
              .thenThrow(ServerException());
          // act
          final result = await repository.getByCriterion(
              level: tLevelSearch,
              subject: tSubjectSearch,
              rateMax: tRateMax,
              rateMin: tRateMin);
          // assert
          verify(mockRemoteDataSource.getAssignmentByCriterion(
              level: tLevelSearch,
              subject: tSubjectSearch,
              rateMax: tRateMax,
              rateMin: tRateMin));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left<Failure, dynamic>(ServerFailure())));
        },
      );
    });
  });
}
