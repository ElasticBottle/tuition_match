import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/data/datasources/auth_service_remote.dart';
import 'package:cotor/data/datasources/user/user_remote_data_source.dart';
import 'package:cotor/data/models/user_entity.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthServiceRepoImpl implements AuthServiceRepo {
  AuthServiceRepoImpl({
    @required this.networkInfo,
    @required this.auth,
    @required this.userRemoteDs,
  });
  final NetworkInfo networkInfo;
  final AuthServiceRemote auth;
  final UserRemoteDataSource userRemoteDs;

  @override
  Stream<User> userStream() => auth.userStream;

  @override
  Future<Either<Failure, User>> getCurrentLoggedInUser() async {
    return IsNetworkOnline<Failure, User>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, User>(
              (await auth.getCurrentUser()).toDomainEntity());
        } on NoUserException {
          return Left<Failure, User>(NoUserFailure());
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> createAccountWithEmail({
    String email,
    String password,
    String phoneNum,
    String firstName,
    String lastName,
  }) async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final bool result = await auth.createAccountWithEmail(
              email: email, password: password);
          await userRemoteDs.createNewUserDocument(
            phoneNum: phoneNum,
            firstname: firstName,
            lastname: lastName,
          );
          return Right<Failure, bool>(result);
        } catch (e) {
          if (e is AuthenticationException) {
            return Left<Failure, bool>(
                AuthenticationFailure(message: e.authError));
          } else if (e is ServerException) {
            return Left<Failure, bool>(ServerFailure());
          } else {
            return Left<Failure, bool>(
                AuthenticationFailure(message: e.toString()));
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> sendEmailVerification() async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, bool>(await auth.sendEmailVerification());
        } catch (e) {
          final AuthenticationException exception = e;
          return Left<Failure, bool>(
              AuthenticationFailure(message: exception.authError));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> isUserEmailVerified() async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, bool>(await auth.isLoggedInUserEmailVerified());
        } catch (e) {
          final AuthenticationException exception = e;
          return Left<Failure, bool>(
              AuthenticationFailure(message: exception.authError));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> sendPasswordResetEmail(String email) async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, bool>(await auth.sendPasswordResetEmail(email));
        } catch (e) {
          final AuthenticationException exception = e;
          return Left<Failure, bool>(
              AuthenticationFailure(message: exception.authError));
        }
      },
    );
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword(
      String email, String password) async {
    return IsNetworkOnline<Failure, User>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final UserEntity user =
              await auth.signInWithEmailAndPassword(email, password);
          return Right<Failure, User>(user.toDomainEntity());
        } catch (e) {
          final AuthenticationException exception = e;
          return Left<Failure, User>(
              AuthenticationFailure(message: exception.authError));
        }
      },
    );
  }

  // @override
  // Future<Either<Failure, User>> signInWithFacebook() async {
  //   return IsNetworkOnline<Failure, User>().call(
  //     networkInfo: networkInfo,
  //     ifOffline: NetworkFailure(),
  //     ifOnline: () async {
  //       try {
  //         return Right<Failure, User>(await auth.signInWithFacebook());
  //       } catch (e) {
  //         final PlatformException exception = e;
  //         return Left<Failure, User>(
  //             AuthenticationFailure(message: exception.message));
  //       }
  //     },
  //   );
  // }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    return IsNetworkOnline<Failure, User>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final UserEntity user = await auth.signInWithGoogle();
          return Right<Failure, User>(user.toDomainEntity());
        } catch (e) {
          final PlatformException exception = e;
          return Left<Failure, User>(
              AuthenticationFailure(message: exception.message));
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    return IsNetworkOnline<Failure, void>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, void>(await auth.signOut());
        } catch (e) {
          final AuthenticationException exception = e;
          return Left<Failure, void>(
              AuthenticationFailure(message: exception.authError));
        }
      },
    );
  }
}
