import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/models/criteria_params.dart';
import 'package:cotor/features/tutee_assignments/data/models/name_model.dart';
import 'package:cotor/features/tutee_assignments/data/models/subject_model.dart';
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

  // DATA FOR THE MOCKS AND ASSERTIONS
  // We'll use these three variables throughout all the tests
  final tLevelSearch = Level.values[2];
  final tSubjectSearch =
      SubjectModel(level: Level.values[2], sbjArea: 'science');
  const double tRateMin = 60.0;
  const double tRateMax = 80.0;

  final CriteriaParams tCriteriaParams = CriteriaParams(
      level: tLevelSearch,
      subject: tSubjectSearch,
      rateMax: tRateMax,
      rateMin: tRateMin);

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

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getAssignmentListByCriterion', () {
    Future<Either<Failure, List<TuteeAssignment>>> _repoCiterionAct() {
      return repository.getByCriterion(tCriteriaParams);
    }

    Future<List<TuteeAssignment>> _remoteDsAct() {
      return mockRemoteDataSource.getAssignmentByCriterion(tCriteriaParams);
    }

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      _repoCiterionAct();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      void _setUpRemoteDs() {
        when(mockRemoteDataSource.getAssignmentByCriterion(tCriteriaParams))
            .thenAnswer((_) async => [tTuteeAssignmentModel]);
      }

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          _setUpRemoteDs();
          // act
          final result = await _repoCiterionAct();
          // assert
          verify(_remoteDsAct());

          final actual = result.fold((l) => null, (r) => r[0].props);
          final expected =
              Right<Failure, List<TuteeAssignment>>([tTuteeAssignment])
                  .fold((l) => null, (r) => r[0].props);
          expect(actual, equals(expected));
        },
      );
      test('Should cache citeria params before returning ServerFailure',
          () async {
        // arrange
        when(mockRemoteDataSource.getAssignmentByCriterion(tCriteriaParams))
            .thenThrow(ServerException());

        // act
        await _repoCiterionAct();

        // assert
        verify(mockLocalDataSource.cacheCriterion(tCriteriaParams));
      });
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getAssignmentByCriterion(tCriteriaParams))
              .thenThrow(ServerException());
          // act
          final result = await _repoCiterionAct();
          // assert
          verify(_remoteDsAct());
          expect(result, equals(Left<Failure, dynamic>(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test('Should cache citeria params', () async {
        // act
        await _repoCiterionAct();

        // assert
        verify(mockLocalDataSource.cacheCriterion(tCriteriaParams));
        verifyZeroInteractions(mockRemoteDataSource);
      });
      test(
        'should return NetworkFailure after caching params',
        () async {
          // act
          final result = await _repoCiterionAct();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left<Failure, dynamic>(NetworkFailure())));
        },
      );
    });
  });

  group('getAssignmentListByCachedCriterion', () {
    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // arrange
      when(mockLocalDataSource.getCachedParams()).thenAnswer(
          (realInvocation) async => CriteriaParams(
              level: tLevelSearch,
              subject: tSubjectSearch,
              rateMax: tRateMax,
              rateMin: tRateMin));
      // act
      repository.getByCachedCriterion();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('should retrieve cached params from local data source', () async {
        // arrange
        when(mockLocalDataSource.getCachedParams())
            .thenAnswer((realInvocation) async => tCriteriaParams);

        // act
        await repository.getByCachedCriterion();
        // assert
        verify(mockLocalDataSource.getCachedParams());
      });
      test('should return [CacheFailure] if there is no cached params',
          () async {
        // arrange
        when(mockLocalDataSource.getCachedParams()).thenThrow(CacheException());
        // act
        final result = await repository.getByCachedCriterion();
        // assert
        verify(mockLocalDataSource.getCachedParams());
        expect(result, Left<Failure, dynamic>(CacheFailure()));
      });
    });
    runTestsOffline(() {
      test('should return NetworkFailure', () async {
        final result = await repository.getByCachedCriterion();
        expect(result, equals(Left<Failure, dynamic>(NetworkFailure())));
      });
    });
  });

  group('getAssignmentList', () {
    Future<Either<Failure, List<TuteeAssignment>>> _repoGetAssignmentAct() {
      return repository.getAssignmentList();
    }

    Future<List<TuteeAssignment>> _remoteDsAct() {
      return mockRemoteDataSource.getAssignmentList();
    }

    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      _repoGetAssignmentAct();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      void _setUpRemoteDs() {
        when(mockRemoteDataSource.getAssignmentList())
            .thenAnswer((_) async => [tTuteeAssignmentModel]);
      }

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          _setUpRemoteDs();
          // act
          final result = await _repoGetAssignmentAct();
          // assert
          verify(_remoteDsAct());

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
          await _repoGetAssignmentAct();
          // assert
          verify(_remoteDsAct());
          verify(mockLocalDataSource.cacheAssignmentList([tTuteeAssignment]));
        },
      );

      test(
        'should return [ServerFailure] when the call to remote data source is unsuccessful.',
        () async {
          // arrange
          when(mockRemoteDataSource.getAssignmentList())
              .thenThrow(ServerException());

          // act
          final result = await _repoGetAssignmentAct();

          // assert
          verify(_remoteDsAct());
          expect(result, equals(Left<Failure, dynamic>(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test('should return NetworkFailure', () async {
        final result = await _repoGetAssignmentAct();
        expect(result, equals(Left<Failure, dynamic>(NetworkFailure())));
      });
    });
  });

  group('getCachedAssignmentList', () {
    test('should check if the device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getCachedAssignmentList();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastAssignmentList())
              .thenAnswer((_) async => [tTuteeAssignmentModel]);
          // act
          final result = await repository.getCachedAssignmentList();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastAssignmentList());
          final actual = result.fold((l) => null, (r) => r[0].props);
          final expected =
              Right<Failure, List<TuteeAssignment>>([tTuteeAssignment])
                  .fold((l) => null, (r) => r[0].props);
          expect(actual, equals(expected));
        },
      );
      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastAssignmentList())
              .thenThrow(CacheException());
          // act
          final result = await repository.getCachedAssignmentList();

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastAssignmentList());
          expect(result, equals(Left<Failure, dynamic>(CacheFailure())));
        },
      );
    });
  });
}
