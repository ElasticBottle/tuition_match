import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/data/datasources/tutee_assignments/tutee_assignment_local_data_source.dart';
import 'package:cotor/data/datasources/tutee_assignments/tutee_assignment_remote_data_source.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/data/models/tutee_criteria_params_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutee_criteria_params.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class TuteeAssignmentRepoImpl implements TuteeAssignmentRepo {
  TuteeAssignmentRepoImpl({
    @required this.remoteDs,
    @required this.localDs,
    @required this.networkInfo,
  });
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
            final List<TuteeAssignmentEntity> assignmentList =
                await remoteDs.getAssignmentList();
            localDs.cacheAssignmentList(assignmentList);
            return _success(
                assignmentList.map((e) => e.toDomainEntity()).toList());
          } catch (e) {
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
                assignmentList?.map((e) => e.toDomainEntity())?.toList());
          } catch (e) {
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
    } catch (e) {
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
      } catch (e) {
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
        } catch (e) {
          return _failure(ServerFailure());
        }
      },
    );
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
      },
    );
  }
}
