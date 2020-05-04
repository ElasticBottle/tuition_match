import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/data/datasources/tutor_profiles/tutor_profile_local_data_sourc.dart';
import 'package:cotor/data/datasources/tutor_profiles/tutor_profile_remote_data_source.dart';
import 'package:cotor/data/models/tutor_criteria_params_entity.dart';
import 'package:cotor/data/models/tutor_profile_entity.dart';
import 'package:cotor/domain/entities/tutor_criteria_params.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/repositories/tutor_profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class TutorProfileRepoImpl implements TutorProfileRepo {
  TutorProfileRepoImpl({
    @required this.remoteDs,
    @required this.localDs,
    @required this.networkInfo,
  });
  final TutorProfileRemoteDataSource remoteDs;
  final TutorProfileLocalDataSource localDs;
  final NetworkInfo networkInfo;

  Left<Failure, List<TutorProfile>> _failure(Failure fail) {
    return Left<Failure, List<TutorProfile>>(fail);
  }

  Right<Failure, List<TutorProfile>> _success(List<TutorProfile> success) {
    return Right<Failure, List<TutorProfile>>(success);
  }

  // Retrieving Assignment List
  @override
  Future<Either<Failure, List<TutorProfile>>> getProfileList() async {
    return IsNetworkOnline<Failure, List<TutorProfile>>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final List<TutorProfileEntity> result =
              await remoteDs.getProfileList();
          localDs.cacheProfileList(result);
          return result == null
              ? _success(<TutorProfile>[])
              : _success(result.map((e) => e.toDomainEntity()).toList());
        } on ServerException {
          return _failure(ServerFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<TutorProfile>>> getNextProfileList() async {
    return IsNetworkOnline<Failure, List<TutorProfile>>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final List<TutorProfileEntity> result =
              await remoteDs.getNextProfileList();
          if (result != null) {
            localDs.cacheProfileList(result, isNew: false);
          }
          return result == null
              ? _success(<TutorProfile>[])
              : _success(result.map((e) => e.toDomainEntity()).toList());
        } on ServerException {
          return _failure(ServerFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<TutorProfile>>> getCachedProfileList() async {
    try {
      final List<TutorProfileEntity> result =
          await localDs.getLastProfileList();
      return _success(result.map((e) => e.toDomainEntity()).toList());
    } on CacheException {
      return _failure(CacheFailure());
    }
  }

  // Retrieving Searched Assignments
  @override
  Future<Either<Failure, List<TutorProfile>>> getByCriterion(
      TutorCriteriaParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final List<TutorProfileEntity> result =
            await remoteDs.getProfileByCriterion(
                TutorCriteriaParamsEntity.fromDomainEntity(params));
        return _success(result.map((e) => e.toDomainEntity()).toList());
      } on ServerException {
        return _cacheCriterionAndReturnFailure(ServerFailure(), params);
      }
    } else {
      return _cacheCriterionAndReturnFailure(NetworkFailure(), params);
    }
  }

  Left<Failure, List<TutorProfile>> _cacheCriterionAndReturnFailure(
      Failure serverFailure, TutorCriteriaParams params) {
    localDs.cacheCriterion(TutorCriteriaParamsEntity.fromDomainEntity(params));
    return _failure(serverFailure);
  }

  @override
  Future<Either<Failure, List<TutorProfile>>> getNextCriterionList() async {
    return IsNetworkOnline<Failure, List<TutorProfile>>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final List<TutorProfileEntity> result =
              await remoteDs.getNextCriterionList();
          return _success(result.map((e) => e.toDomainEntity()).toList());
        } on ServerException {
          return _failure(ServerFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<TutorProfile>>> getByCachedCriterion() async {
    return IsNetworkOnline<Failure, List<TutorProfile>>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final TutorCriteriaParamsEntity params =
              await localDs.getCachedParams();
          return await getByCriterion(params.toDomainEntity());
        } on CacheException {
          return _failure(CacheFailure());
        }
      },
    );
  }
}
