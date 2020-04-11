import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/data/datasources/user_remote_data_source.dart';
import 'package:cotor/data/models/criteria_params.dart';
import 'package:cotor/data/models/del_params.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class TuteeAssignmentRepoImpl implements TuteeAssignmentRepo {
  TuteeAssignmentRepoImpl({
    @required this.remoteDs,
    @required this.localDs,
    @required this.networkInfo,
    @required this.userDs,
  });
  final TuteeAssignmentRemoteDataSource remoteDs;
  final TuteeAssignmentLocalDataSource localDs;
  final UserRemoteDataSource userDs;
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
  Future<Either<Failure, List<TuteeAssignment>>> getNextAssignmentList() async {
    return IsNetworkOnline<Failure, List<TuteeAssignment>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final List<TuteeAssignment> result =
                await remoteDs.getNextAssignmentList();
            if (result != null) {
              localDs.cacheToExistingAssignmentList(result);
            }
            return _success(result);
          } on ServerException {
            return _failure(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>>
      getCachedAssignmentList() async {
    try {
      final List<TuteeAssignment> result =
          await localDs.getLastAssignmentList();
      return _success(result);
    } on CacheException {
      return _failure(CacheFailure());
    }
  }

  // Retrieving Searched Assignments
  @override
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion(
      CriteriaParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final List<TuteeAssignment> result =
            await remoteDs.getAssignmentByCriterion(params);
        return _success(result);
      } on ServerException {
        return _cacheCriterionAndReturnFailure(ServerFailure(), params);
      }
    } else {
      return _cacheCriterionAndReturnFailure(NetworkFailure(), params);
    }
  }

  Left<Failure, List<TuteeAssignment>> _cacheCriterionAndReturnFailure(
      Failure serverFailure, CriteriaParams params) {
    localDs.cacheCriterion(params);
    return _failure(serverFailure);
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getNextCriterionList() {
    return IsNetworkOnline<Failure, List<TuteeAssignment>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final List<TuteeAssignment> result =
                await remoteDs.getNextCriterionList();
            return _success(result);
          } on ServerException {
            return _failure(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getByCachedCriterion() async {
    return IsNetworkOnline<Failure, List<TuteeAssignment>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final CriteriaParams params = await localDs.getCachedParams();
            return await getByCriterion(params);
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
            final bool result = await userDs.delAssignment(
                postId: params.postId, username: params.username);
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

  // Update and creation of assignments
  @override
  Future<Either<Failure, TuteeAssignmentModel>>
      getCachedTuteeAssignmentToSet() async {
    try {
      final TuteeAssignmentModel result =
          await localDs.getCachedTuteeAssignmentToSet();
      return Right<Failure, TuteeAssignmentModel>(result);
    } on CacheException {
      return Left<Failure, TuteeAssignmentModel>(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setTuteeAssignment(
      TuteeAssignmentModel params) {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final bool result =
                await userDs.setTuteeAssignment(tuteeParams: params);
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, bool>> updateTuteeAssignment(
      TuteeAssignmentModel params) {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final bool result =
                await userDs.updateTuteeAssignment(tuteeParams: params);
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }
}
