import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/get_tutee_assignments_by_criterion.dart';
import 'package:dartz/dartz.dart';

class TuteeAssignmentRepoImpl implements TuteeAssignmentRepo {
  TuteeAssignmentRepoImpl({this.remoteDs, this.localDs, this.networkInfo});
  final TuteeAssignmentRemoteDataSource remoteDs;
  final TuteeAssignmentLocalDataSource localDs;
  final NetworkInfo networkInfo;

  Left<Failure, List<TuteeAssignment>> _failure(Failure fail) {
    return Left<Failure, List<TuteeAssignment>>(fail);
  }

  Right<Failure, List<TuteeAssignment>> _success(
      List<TuteeAssignment> success) {
    return Right<Failure, List<TuteeAssignment>>(success);
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList() async {
    if (await networkInfo.isConnected) {
      try {
        final List<TuteeAssignment> result = await remoteDs.getAssignmentList();
        localDs.cacheAssignmentList(result);
        return _success(result);
      } on ServerException {
        return _failure(ServerFailure());
      }
    } else {
      return _failure(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>>
      getCachedAssignmentList() async {
    if (await networkInfo.isConnected) {
      return await getAssignmentList();
    } else {
      try {
        final List<TuteeAssignment> result =
            await localDs.getLastAssignmentList();
        return _success(result);
      } on CacheException {
        return _failure(CacheFailure());
      }
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
        return _success(result);
      } on ServerException {
        return _cacheCriterionAndReturnFailure(
          ServerFailure(),
          level: level,
          rateMax: rateMax,
          rateMin: rateMin,
          subject: subject,
        );
      }
    } else {
      return _cacheCriterionAndReturnFailure(
        NetworkFailure(),
        level: level,
        rateMax: rateMax,
        rateMin: rateMin,
        subject: subject,
      );
    }
  }

  Left<Failure, List<TuteeAssignment>> _cacheCriterionAndReturnFailure(
      Failure serverFailure,
      {Level level,
      double rateMax,
      double rateMin,
      Subject subject}) {
    localDs.cacheCriterion(
      level: level,
      rateMax: rateMax,
      rateMin: rateMin,
      subject: subject,
    );
    return _failure(serverFailure);
  }

  Future<Either<Failure, List<TuteeAssignment>>> getNextCriterionList() {}

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getByCachedCriterion({
    Level level,
    Subject subject,
    double rateMin,
    double rateMax,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final Params params = await localDs.getCachedParams();
        return await getByCriterion(
            level: params.level,
            subject: params.subject,
            rateMin: params.rateMin,
            rateMax: params.rateMax);
      } on CacheException {
        return _failure(CacheFailure());
      }
    } else {
      return _failure(NetworkFailure());
    }
  }
}
