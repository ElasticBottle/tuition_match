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
    @required this.userData,
    @required this.networkInfo,
  });
  final UserRemoteDataSource userData;
  final NetworkInfo networkInfo;

  @override
  void dispose() {}

  @override
  Future<Either<Failure, User>> getCurrentLoggedInUser() async {
    return IsNetworkOnline<Failure, User>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return await userData.getCurrentUser();
        } on NoUserException {
          return Left<Failure, User>(NoUserFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> createNewUser({
    String emaail,
    String username,
    String firstname,
    String lastname,
  }) {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return await userData.createNewUserDocument(
            username: username,
            firstname: firstname,
            lastname: lastname,
          );
        } on ServerException {
          return Left<Failure, User>(ServerFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, User>> getUserInfo(String username) {
    return IsNetworkOnline<Failure, User>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return await userData.getUserInfo(username);
        } on ServerException {
          return Left<Failure, User>(ServerFailure());
        } on NoUserException {
          return Left<Failure, User>(NoUserFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, PrivateUserInfo>> getUserPrivateInfo(String username) {
    return IsNetworkOnline<Failure, PrivateUserInfo>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return await userData.getUserPrivateInfo(username);
        } on ServerException {
          return Left<Failure, User>(ServerFailure());
        }
      },
    );
  }
}
