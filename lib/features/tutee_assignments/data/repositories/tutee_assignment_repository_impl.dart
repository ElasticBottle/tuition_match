import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/del_tutee_assignment.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/get_tutee_assignments_by_criterion.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/set_tutee_assignment.dart';
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

  // Retrieving Assignment List
  @override
  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList() async {
    return IsNetworkOnline<Failure, List<TuteeAssignment>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final List<TuteeAssignment> result =
                await remoteDs.getAssignmentList();
            localDs.cacheAssignmentList(result);
            return _success(result);
          } on ServerException {
            return _failure(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getNextAssignmentList() {
    // TODO(ElasticBottle): implement getNextAssignmentList
    throw UnimplementedError();
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

  // Retrieving Searched Assignments
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

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getNextCriterionList() {
    // TODO(ElasticBottle): implement getNextCriterionList
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getByCachedCriterion() async {
    return IsNetworkOnline<Failure, List<TuteeAssignment>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final CriteriaParams params = await localDs.getCachedParams();
            return await getByCriterion(
                level: params.level,
                subject: params.subject,
                rateMin: params.rateMin,
                rateMax: params.rateMax);
          } on CacheException {
            return _failure(CacheFailure());
          }
        });
  }

  // Deleting Assingments
  @override
  Future<Either<Failure, bool>> delAssignment(DelParams params) async {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final bool result =
                await remoteDs.delAssignment(postId: params.postId);
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

  // Update and creation of assignments
  @override
  Future<Either<Failure, TuteeAssignmentParams>>
      getCachedTuteeAssignmentToSet() async {
    try {
      final TuteeAssignmentParams result =
          await localDs.getCachedTuteeAssignmentToSet();
      return Right<Failure, TuteeAssignmentParams>(result);
    } on CacheException {
      return Left<Failure, TuteeAssignmentParams>(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setTuteeAssignment(
      TuteeAssignmentParams params) {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final bool result =
                await remoteDs.setTuteeAssignment(tuteeParmas: params);
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, bool>> updateTuteeAssignment(
      TuteeAssignmentParams params) {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          MakeDSCall<ServerException, bool>().call(
            dsCall: () {
              remoteDs.updateTuteeAssignment(tuteeParmas: params);
            },
            ifFail: ServerFailure(),
          );
        });
  }
}

class MakeDSCall<Exception, T> {
  Future<Either<Failure, T>> call({Function dsCall, Failure ifFail}) async {
    try {
      final T result = await dsCall();
      return Right<Failure, T>(result);
    } on Exception {
      return Left<Failure, T>(ifFail);
    }
  }
}
