import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class TuteeAssignmentRepoImpl implements TuteeAssignmentRepo {
  TuteeAssignmentRepoImpl({this.remoteDs, this.localDs, this.networkInfo});
  final TuteeAssignmentRemoteDataSource remoteDs;
  final TuteeAssignmentLocalDataSource localDs;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList() async {
    if (await networkInfo.isConnected) {
      try {
        final List<TuteeAssignment> result = await remoteDs.getAssignmentList();
        localDs.cacheAssignmentList(result);
        return Right<Failure, List<TuteeAssignment>>(result);
      } on ServerException {
        return await _attemptAssignmentListRetrievalFromCache(ServerFailure());
      }
    } else {
      return await _attemptAssignmentListRetrievalFromCache(CacheFailure());
    }
  }

  Future<Either<Failure, List<TuteeAssignment>>>
      _attemptAssignmentListRetrievalFromCache(Failure failure) async {
    try {
      final List<TuteeAssignment> result =
          await localDs.getLastAssignmentList();
      return Right<Failure, List<TuteeAssignment>>(result);
    } on CacheException {
      return Left<Failure, List<TuteeAssignment>>(failure);
    }
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion({
    Level level,
    Subject subject,
    double rateMin,
    double rateMax,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final List<TuteeAssignment> result =
            await remoteDs.getAssignmentByCriterion(
          level: level,
          subject: subject,
          rateMax: rateMax,
          rateMin: rateMin,
        );
        return Right<Failure, List<TuteeAssignment>>(result);
      } on ServerException {
        return Left<Failure, List<TuteeAssignment>>(ServerFailure());
      }
    } else {
      localDs.cacheCriterion(
        level: level,
        rateMax: rateMax,
        rateMin: rateMin,
        subject: subject,
      );
      return Left<Failure, List<TuteeAssignment>>(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getByCachedCriterion({
    Level level,
    Subject subject,
    double rateMin,
    double rateMax,
  }) {
    // TODO: implement getByCachedCriterion
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getCachedAssignmentList() {
    // TODO: implement getCachedAssignmentList
    throw UnimplementedError();
  }
}
