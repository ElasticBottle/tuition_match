import 'dart:async';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/data/datasources/user/user_local_data_source.dart';
import 'package:cotor/data/datasources/user/user_remote_data_source.dart';
import 'package:cotor/data/models/tutee_assignment_entity.dart';
import 'package:cotor/data/models/tutor_profile_entity.dart';
import 'package:cotor/data/models/user_entity.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class UserRepoImpl implements UserRepo {
  UserRepoImpl({
    @required this.userDs,
    @required this.localDs,
    @required this.networkInfo,
  })  : assert(userDs != null),
        assert(localDs != null),
        assert(networkInfo != null);
  final UserRemoteDataSource userDs;
  final UserLocalDataSource localDs;
  final NetworkInfo networkInfo;

//////////////////////////////////////////////////////////////////////
//   ___                       _                      _       __
//  / __|___ _ _  ___ _ _ __ _| |  _  _ ___ ___ _ _  (_)_ _  / _|___
// | (_ / -_) ' \/ -_) '_/ _` | | | || (_-</ -_) '_| | | ' \|  _/ _ \
//  \___\___|_||_\___|_| \__,_|_|  \_,_/__/\___|_|   |_|_||_|_| \___/
//
//////////////////////////////////////////////////////////////////////

  @override
  Stream<User> userProfileStream(String uid) => userDs.userProfileStream(uid);

  @override
  Future<Either<Failure, User>> getUserInfo(String uid) async {
    return IsNetworkOnline<Failure, User>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final UserEntity result = await userDs.getUserInfo(uid);
          return Right<Failure, User>(result.toDomainEntity());
        } on ServerException {
          return Left<Failure, User>(ServerFailure());
        } on NoUserException {
          print('returning no user failure');
          return Left<Failure, User>(NoUserFailure());
        }
      },
    );
  }

  // TODO(ElasticBottle): map retrieved response from datasource to correct object to return
  @override
  Future<Either<Failure, PrivateUserInfo>> getUserPrivateInfo(
      String uid) async {
    return IsNetworkOnline<Failure, PrivateUserInfo>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, PrivateUserInfo>(
              await userDs.getUserPrivateInfo(uid));
        } on ServerException {
          return Left<Failure, PrivateUserInfo>(ServerFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> createNewUserDocument({
    String uid,
    String photoUrl,
    String firstname,
    String lastname,
    String phoneNum,
  }) async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          await userDs.createNewUserDocument(
            uid: uid,
            photoUrl: photoUrl,
            firstname: firstname,
            lastname: lastname,
            phoneNum: phoneNum,
          );
          return Right<Failure, bool>(true);
        } catch (e) {
          print('in user repo impl ' + e.toString());
          return Left<Failure, bool>(ServerFailure());
        }
      },
    );
  }

/////////////////////////////////////
//  ___                      _
// | _ \___ __ _ _  _ ___ __| |_ ___
// |   / -_) _` | || / -_|_-<  _(_-<
// |_|_\___\__, |\_,_\___/__/\__/__/
//            |_|
/////////////////////////////////////
  @override
  Future<Either<Failure, bool>> requestTutor(
      {String uid,
      TuteeAssignment assignment,
      bool isNewAssignment,
      bool toSave}) {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, bool>(
            await userDs.requestTutor(
              requestUid: uid,
              assignment: TuteeAssignmentEntity.fromDomainEntity(assignment),
              isNewAssignment: isNewAssignment,
              toSave: toSave,
            ),
          );
        } on ServerException {
          return Left<Failure, bool>(ServerFailure());
        }
      },
    );
  }

////////////////////////////////////////////////////////////////////
//  _   _                 _          _                         _
// | | | |___ ___ _ _    /_\   _____(_)__ _ _ _  _ __  ___ _ _| |_
// | |_| (_-</ -_) '_|  / _ \ (_-<_-< / _` | ' \| '  \/ -_) ' \  _|
//  \___//__/\___|_|   /_/ \_\/__/__/_\__, |_||_|_|_|_\___|_||_\__|
//                                    |___/
////////////////////////////////////////////////////////////////////
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
          } catch (e) {
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
          } catch (e) {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

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
          } catch (e) {
            return Left<Failure, bool>(ServerFailure());
          }
        });
  }

////////////////////////////////////////////////
//  _   _               ___          __ _ _
// | | | |___ ___ _ _  | _ \_ _ ___ / _(_) |___
// | |_| (_-</ -_) '_| |  _/ '_/ _ \  _| | / -_)
//  \___//__/\___|_|   |_| |_| \___/_| |_|_\___|
////////////////////////////////////////////////

  @override
  Future<Either<Failure, void>> cacheTutorProfileToSet(
      TutorProfile profile) async {
    return Right<Failure, void>(await localDs
        .cacheTutorProfileToSet(TutorProfileEntity.fromDomainEntity(profile)));
  }

  @override
  Future<Either<Failure, TutorProfile>> getCachedTutorProfileToSet() async {
    try {
      final TutorProfileEntity result =
          await localDs.getCachedTutorProfileToSet();
      return Right<Failure, TutorProfile>(result.toDomainEntity());
    } on CacheException {
      return Left<Failure, TutorProfile>(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setTutorProfile(TutorProfile profile) async {
    return await _setTutorProfile(
      profile,
      () {
        return userDs.setTutorProfile(
            tutorProfile: TutorProfileEntity.fromDomainEntity(profile));
      },
    );
  }

  @override
  Future<Either<Failure, bool>> updateTutorProfile(TutorProfile profile) async {
    return await _setTutorProfile(
      profile,
      () {
        return userDs.updateTutorProfile(
            tutorProfile: TutorProfileEntity.fromDomainEntity(profile));
      },
    );
  }

  Future<Either<Failure, bool>> _setTutorProfile(
      TutorProfile profile, Function databaseCall) async {
    localDs
        .cacheTutorProfileToSet(TutorProfileEntity.fromDomainEntity(profile));
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final bool result = await databaseCall();
          bool isCacheCleared = false;
          while (!isCacheCleared) {
            isCacheCleared = await localDs.clearCacheTutorProfile();
          }
          return Right<Failure, bool>(result);
        } on ServerException {
          return Left<Failure, bool>(ServerFailure());
        }
      },
    );
  }

  // Deleting Assingments
  @override
  Future<Either<Failure, bool>> delProfile(String uid) async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final bool result = await userDs.delProfile(uid: uid);
          return Right<Failure, bool>(result);
        } on ServerException {
          return Left<Failure, bool>(ServerFailure());
        }
      },
    );
  }
}
