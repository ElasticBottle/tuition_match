import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/data/datasources/auth_service_remote.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/data/models/user/user_entity.dart';
import 'package:cotor/domain/entities/user/user.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthServiceRepoImpl implements AuthServiceRepo {
  AuthServiceRepoImpl({
    @required this.networkInfo,
    @required this.auth,
  });
  final NetworkInfo networkInfo;
  final AuthServiceRemote auth;

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
        } catch (e) {
          if (e is NoUserException) {
            return Left<Failure, User>(NoUserFailure());
          } else if (e is AuthenticationException) {
            return Left<Failure, User>(
                AuthenticationFailure(message: e.toString()));
          } else {
            return Left<Failure, User>(NoUserFailure());
          }
        }
      },
    );
  }

//  ___ _             _   _
// / __(_)__ _ _ _   | | | |_ __
// \__ \ / _` | ' \  | |_| | '_ \
// |___/_\__, |_||_|  \___/| .__/
//       |___/             |_|
  @override
  Future<Either<Failure, bool>> createAccountWithEmail({
    String email,
    String password,
  }) async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final bool result = await auth.createAccountWithEmail(
              email: email, password: password);
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
  Future<Either<Failure, bool>> sendEmailVerification() async {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, bool>(await auth.sendEmailVerification());
        } catch (e) {
          return Left<Failure, bool>(SendEmailFailure());
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

//  ___ _             ___
// / __(_)__ _ _ _   |_ _|_ _
// \__ \ / _` | ' \   | || ' \
// |___/_\__, |_||_| |___|_||_|
//       |___/

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
        } catch (e, stacktrace) {
          print(stacktrace);
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
        return Right<Failure, void>(await auth.signOut());
      },
    );
  }
}
