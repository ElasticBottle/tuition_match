import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/data/datasources/tutor_profile_local_data_sourc.dart';
import 'package:cotor/data/datasources/tutor_profile_remote_data_source.dart';
import 'package:cotor/data/datasources/user_remote_data_source.dart';
import 'package:cotor/data/models/criteria_params.dart';
import 'package:cotor/data/models/del_params.dart';
import 'package:cotor/data/models/tutor_profile_model.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/repositories/tutor_profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class TutorProfileRepoImpl implements TutorProfileRepo {
  TutorProfileRepoImpl({
    @required this.remoteDs,
    @required this.localDs,
    @required this.networkInfo,
    @required this.userDs,
  });
  final TutorProfileRemoteDataSource remoteDs;
  final TutorProfileLocalDataSource localDs;
  final UserRemoteDataSource userDs;
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
            final List<TutorProfile> result = await remoteDs.getProfileList();
            localDs.cacheProfileList(result);
            return _success(result);
          } on ServerException {
            return _failure(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, List<TutorProfile>>> getNextProfileList() async {
    return IsNetworkOnline<Failure, List<TutorProfile>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final List<TutorProfile> result =
                await remoteDs.getNextProfileList();
            if (result != null) {
              localDs.cacheToExistingProfileList(result);
            }
            return _success(result);
          } on ServerException {
            return _failure(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, List<TutorProfile>>> getCachedProfileList() async {
    try {
      final List<TutorProfile> result = await localDs.getLastProfileList();
      return _success(result);
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
        final List<TutorProfile> result =
            await remoteDs.getProfileByCriterion(params);
        return _success(result);
      } on ServerException {
        return _cacheCriterionAndReturnFailure(ServerFailure(), params);
      }
    } else {
      return _cacheCriterionAndReturnFailure(NetworkFailure(), params);
    }
  }

  Left<Failure, List<TutorProfile>> _cacheCriterionAndReturnFailure(
      Failure serverFailure, TutorCriteriaParams params) {
    localDs.cacheCriterion(params);
    return _failure(serverFailure);
  }

  @override
  Future<Either<Failure, List<TutorProfile>>> getNextCriterionList() {
    return IsNetworkOnline<Failure, List<TutorProfile>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final List<TutorProfile> result =
                await remoteDs.getNextCriterionList();
            return _success(result);
          } on ServerException {
            return _failure(ServerFailure());
          }
        });
  }

  @override
  Future<Either<Failure, List<TutorProfile>>> getByCachedCriterion() async {
    return IsNetworkOnline<Failure, List<TutorProfile>>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final TutorCriteriaParams params = await localDs.getCachedParams();
            return await getByCriterion(params);
          } on CacheException {
            return _failure(CacheFailure());
          }
        });
  }

  // Deleting Assingments
  @override
  Future<Either<Failure, bool>> delProfile(DelParams params) async {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          try {
            final bool result =
                await userDs.delProfile(username: params.username);
            return Right<Failure, bool>(result);
          } on ServerException {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

  // Update and creation of assignments
  @override
  Future<Either<Failure, TutorProfileModel>>
      getCachedTutorProfileToSet() async {
    try {
      final TutorProfileModel result =
          await localDs.getCachedTutorProfileToSet();
      return Right<Failure, TutorProfileModel>(result);
    } on CacheException {
      return Left<Failure, TutorProfileModel>(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setTutorProfile(TutorProfileModel params) {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          return await _setTutorProfile(
            params,
            () {
              return userDs.setTutorProfile(tutorParams: params);
            },
          );
        });
  }

  @override
  Future<Either<Failure, bool>> updateTutorProfile(TutorProfileModel params) {
    return IsNetworkOnline<Failure, bool>().call(
        networkInfo: networkInfo,
        ifOffline: NetworkFailure(),
        ifOnline: () async {
          return await _setTutorProfile(
            params,
            () {
              return userDs.updateTutorProfile(tutorParams: params);
            },
          );
        });
  }

  Future<Either<Failure, bool>> _setTutorProfile(
      TutorProfileModel params, Function settingCall) async {
    localDs.cacheTutorProfileToSet(params);
    try {
      final bool result = await settingCall();
      bool isCacheCleared = false;
      while (!isCacheCleared) {
        isCacheCleared = await localDs.clearCacheTutorProfile();
      }
      localDs.clearCacheTutorProfile();
      return Right<Failure, bool>(result);
    } on ServerException {
      return Left<Failure, bool>(ServerFailure());
    }
  }
}
