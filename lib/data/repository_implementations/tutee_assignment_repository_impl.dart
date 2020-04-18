import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/data/datasources/user_remote_data_source.dart';
import 'package:cotor/data/models/tutee_assignment_entity.dart';
import 'package:cotor/data/models/tutee_criteria_params_entity.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutee_criteria_params.dart';
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
            final List<TuteeAssignmentEntity> assignmentList =
                await remoteDs.getAssignmentList();
            localDs.cacheAssignmentList(assignmentList);
            return _success(
                assignmentList.map((e) => e.toDomainEntity()).toList());
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
            final List<TuteeAssignmentEntity> assignmentList =
                await remoteDs.getNextAssignmentList();
            if (assignmentList != null) {
              localDs.cacheAssignmentList(assignmentList, isNew: false);
            }
            return _success(
                assignmentList.map((e) => e.toDomainEntity()).toList());
          } on ServerException {
            return _failure(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>>
      getCachedAssignmentList() async {
    try {
      final List<TuteeAssignmentEntity> result =
          await localDs.getLastAssignmentList();
      return _success(result.map((e) => e.toDomainEntity()).toList());
    } on CacheException {
      return _failure(CacheFailure());
    }
  }

  // Retrieving Searched Assignments
  @override
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion(
      TuteeCriteriaParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final List<TuteeAssignmentEntity> result =
            await remoteDs.getAssignmentByCriterion(params);
        return _success(result.map((e) => e.toDomainEntity()).toList());
      } on ServerException {
        return _cacheCriterionAndReturnFailure(ServerFailure(), params);
      }
    } else {
      return _cacheCriterionAndReturnFailure(NetworkFailure(), params);
    }
  }

  Left<Failure, List<TuteeAssignment>> _cacheCriterionAndReturnFailure(
      Failure serverFailure, TuteeCriteriaParams params) {
    localDs.cacheCriterion(TuteeCriteriaParamsEntity.fromDomainEntity(params));
    return _failure(serverFailure);
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getNextCriterionList() async {
    return IsNetworkOnline<Failure, List<TuteeAssignment>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final List<TuteeAssignmentEntity> result =
                await remoteDs.getNextCriterionList();
            return _success(result.map((e) => e.toDomainEntity()).toList());
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
            final TuteeCriteriaParamsEntity params =
                await localDs.getCachedParams();
            return await getByCriterion(params.toDomainEntity());
          } on CacheException {
            return _failure(CacheFailure());
          }
        });
  }

  // Deleting Assingments
  @override
  Future<Either<Failure, bool>> delAssignment(
      {String postId, String uid}) async {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final bool result =
                await userDs.delAssignment(postId: postId, uid: uid);
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

  // Update and creation of assignments
  @override
  Future<Either<Failure, TuteeAssignment>>
      getCachedTuteeAssignmentToSet() async {
    try {
      final TuteeAssignmentEntity result =
          await localDs.getCachedTuteeAssignmentToSet();
      return Right<Failure, TuteeAssignment>(result.toDomainEntity());
    } on CacheException {
      return Left<Failure, TuteeAssignment>(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setTuteeAssignment(
      TuteeAssignment assignment) async {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final bool result = await userDs.setTuteeAssignment(
                tuteeParams:
                    TuteeAssignmentEntity.fromDomainEntity(assignment));
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, bool>> updateTuteeAssignment(
      TuteeAssignment assignment) async {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final bool result = await userDs.updateTuteeAssignment(
                tuteeParams:
                    TuteeAssignmentEntity.fromDomainEntity(assignment));
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }
}
