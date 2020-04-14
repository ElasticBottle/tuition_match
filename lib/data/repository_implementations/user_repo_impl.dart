import 'dart:async';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/data/datasources/user_remote_data_source.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class UserRepoImpl implements UserRepo {
  UserRepoImpl({
    @required this.userDs,
    @required this.networkInfo,
  });
  final UserRemoteDataSource userDs;
  final NetworkInfo networkInfo;

  @override
  void dispose() {}

  @override
  Stream<User> userProfileStream(String uid) => userDs.userProfileStream(uid);

  @override
  Stream<User> userStream() => userDs.userStream;

  @override
  Future<Either<Failure, User>> getCurrentLoggedInUser() async {
    return IsNetworkOnline<Failure, User>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, User>(await userDs.getCurrentUser());
        } on NoUserException {
          return Left<Failure, User>(NoUserFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> createNewUser({
    String email,
    String firstname,
    String lastname,
    String phoneNum,
  }) async {
    return IsNetworkOnline<Failure, void>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, void>(await userDs.createNewUserDocument(
            firstname: firstname,
            lastname: lastname,
            phoneNum: phoneNum,
          ));
        } catch (e) {
          print('in user repo impl ' + e.toString());
          print('serverEception');
          return Left<Failure, void>(ServerFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, User>> getUserInfo(String uid) async {
    return IsNetworkOnline<Failure, User>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final User result = await userDs.getUserInfo(uid);
          return Right<Failure, User>(result);
        } on ServerException {
          return Left<Failure, User>(ServerFailure());
        } on NoUserException {
          print('returning no user failure');
          return Left<Failure, User>(NoUserFailure());
        }
      },
    );
  }

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
          return Left<Failure, User>(ServerFailure());
        }
      },
    );
  }
}
