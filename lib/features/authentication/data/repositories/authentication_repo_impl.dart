import 'package:cotor/core/error/exception.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/authentication/data/datasources/authentication_remote.dart';
import 'package:cotor/features/authentication/data/models/authernticated_user_model.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AuthenticationRepoImpl implements AuthenticationRepo {
  AuthenticationRepoImpl({
    @required this.networkInfo,
    @required this.auth,
  });
  final NetworkInfo networkInfo;
  final AuthenticationRemote auth;

  @override
  Stream<AuthenticatedUser> userStream() => auth.userStream;

  @override
  Future<Either<Failure, AuthenticatedUser>> getCurrentLoggedInUser() async {
    return IsNetworkOnline<Failure, AuthenticatedUser>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          return Right<Failure, AuthenticatedUser>(
              (await auth.getCurrentUser()).toDomainEntity());
        } catch (e) {
          if (e is NoUserException) {
            return Left<Failure, AuthenticatedUser>(NoUserFailure());
          } else if (e is AuthenticationException) {
            return Left<Failure, AuthenticatedUser>(
                AuthenticationFailure(message: e.toString()));
          } else {
            return Left<Failure, AuthenticatedUser>(NoUserFailure());
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
  Future<Either<Failure, AuthenticatedUser>> createAccountWithEmail({
    String email,
    String password,
  }) async {
    return IsNetworkOnline<Failure, AuthenticatedUserModel>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final AuthenticatedUserModel result = await auth
              .createAccountWithEmail(email: email, password: password);
          return Right<Failure, AuthenticatedUser>(result.toDomainEntity());
        } catch (e) {
          if (e is AuthenticationException) {
            return Left<Failure, AuthenticatedUser>(
                AuthenticationFailure(message: e.authError));
          } else {
            return Left<Failure, AuthenticatedUser>(
                AuthenticationFailure(message: e.toString()));
          }
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> createNewUserDocument({
    String uid,
    String photoUrl,
    String firstName,
    String lastName,
    String countryCode,
    String phoneNum,
  }) {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          await auth.createNewUserDocument(
            uid: uid,
            firstName: firstName,
            lastName: lastName,
            phoneNum: phoneNum,
            countryCode: countryCode,
          );
          return Right<Failure, bool>(true);
        } catch (e) {
          print('in user repo impl ' + e.toString());
          return Left<Failure, bool>(ServerFailure());
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
  Future<Either<Failure, AuthenticatedUser>> signInWithEmailAndPassword(
      String email, String password) async {
    return IsNetworkOnline<Failure, AuthenticatedUser>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final AuthenticatedUserModel user =
              await auth.signInWithEmailAndPassword(email, password);
          return Right<Failure, AuthenticatedUser>(user.toDomainEntity());
        } catch (e) {
          final AuthenticationException exception = e;
          return Left<Failure, AuthenticatedUser>(
              AuthenticationFailure(message: exception.authError));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> isUserProfileCreated(String uid) {
    return IsNetworkOnline<Failure, bool>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final bool result = await auth.isUserProfileCreated(uid);
          return Right<Failure, bool>(result);
        } catch (e, stacktrace) {
          print(e);
          print(stacktrace);
          return Left<Failure, bool>(ServerFailure());
        }
      },
    );
  }

  // @override
  // Future<Either<Failure, AuthenticatedUser>> signInWithFacebook() async {
  //   return IsNetworkOnline<Failure, AuthenticatedUser>().call(
  //     networkInfo: networkInfo,
  //     ifOffline: NetworkFailure(),
  //     ifOnline: () async {
  //       try {
  //         return Right<Failure, AuthenticatedUser>(await auth.signInWithFacebook());
  //       } catch (e) {
  //         final PlatformException exception = e;
  //         return Left<Failure, AuthenticatedUser>(
  //             AuthenticationFailure(message: exception.message));
  //       }
  //     },
  //   );
  // }

  @override
  Future<Either<Failure, AuthenticatedUser>> signInWithGoogle() async {
    return IsNetworkOnline<Failure, AuthenticatedUser>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        try {
          final AuthenticatedUserModel user = await auth.signInWithGoogle();
          return Right<Failure, AuthenticatedUser>(user.toDomainEntity());
        } catch (e, stacktrace) {
          print(stacktrace);
          final PlatformException exception = e;
          return Left<Failure, AuthenticatedUser>(
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
