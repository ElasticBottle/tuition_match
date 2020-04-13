import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/data/datasources/auth_service_remote.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthServiceRepoImpl implements AuthServiceRepo {
  AuthServiceRepoImpl({
    @required this.networkInfo,
    @required this.auth,
    @required this.userRepo,
  });
  final NetworkInfo networkInfo;
  final AuthServiceRemote auth;
  final UserRepo userRepo;

  @override
  Future<Either<Failure, bool>> isUsernameValid(String username) async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final bool result = await auth.isUsernameValid(username);
          return Right<Failure, bool>(result);
        } catch (e) {
          if (e is AuthenticationException) {
            return Left<Failure, bool>(
                AuthenticationFailure(message: e.authError));
          } else {
            return Left<Failure, bool>(
                AuthenticationFailure(message: e.toString()));
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> createAccountWithEmail({
    String email,
    String password,
    String username,
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
          await userRepo.createNewUser(
            email: email,
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
  Future<Either<Failure, void>> sendEmailVerification() async {
    return IsNetworkOnline<Failure, void>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, void>(await auth.sendEmailVerification());
        } catch (e) {
          final AuthenticationException exception = e;
          return Left<Failure, void>(
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
  Future<void> sendPasswordResetEmail(String email) async {
    return IsNetworkOnline<Failure, void>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, void>(await auth.sendPasswordResetEmail(email));
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
          return Right<Failure, User>(
              await auth.signInWithEmailAndPassword(email, password));
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
          return Right<Failure, User>(await auth.signInWithGoogle());
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

  @override
  void dispose() {}
}
