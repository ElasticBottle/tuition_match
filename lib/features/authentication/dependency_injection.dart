import 'package:cotor/features/authentication/data/datasources/authentication_remote.dart';
import 'package:cotor/features/authentication/data/repositories/authentication_repo_impl.dart';
import 'package:cotor/features/authentication/data/repositories/misc_repo_impl.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:cotor/features/authentication/domain/repositories/misc_repo.dart';
import 'package:cotor/features/authentication/domain/usecases/create_account_with_email.dart';
import 'package:cotor/features/authentication/domain/usecases/create_user_document.dart';
import 'package:cotor/features/authentication/domain/usecases/forget_password.dart';
import 'package:cotor/features/authentication/domain/usecases/get_current_user.dart';
import 'package:cotor/features/authentication/domain/usecases/is_first_app_launch.dart';
import 'package:cotor/features/authentication/domain/usecases/is_user_profile_created.dart';
import 'package:cotor/features/authentication/domain/usecases/send_email_verification.dart';
import 'package:cotor/features/authentication/domain/usecases/set_is_first_app_launch_false.dart';
import 'package:cotor/features/authentication/domain/usecases/sign_in_with_email.dart';
import 'package:cotor/features/authentication/domain/usecases/sign_in_with_google.dart';
import 'package:cotor/features/authentication/domain/usecases/sign_out.dart';
import 'package:cotor/features/authentication/domain/usecases/user_stream.dart';
import 'package:cotor/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:cotor/features/authentication/presentation/pages/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:cotor/features/authentication/presentation/pages/login/bloc/login_bloc.dart';
import 'package:cotor/features/authentication/presentation/pages/registration/bloc/registration_bloc.dart';
import 'package:cotor/features/authentication/presentation/pages/verify_email/bloc/verify_email_bloc.dart';
import 'package:get_it/get_it.dart';

class AuthenticationDependency {
  static void initialise(GetIt getIt) {
    // Bloc
    getIt
        .registerFactory(() => VerifyEmailBloc(sendEmailVerification: getIt()));
    getIt.registerFactory(() => RegistrationBloc(
        createAccountWithEmail: getIt(),
        createUserDocument: getIt(),
        validator: getIt()));
    getIt.registerFactory(() => LoginBloc(
        signInWithEmail: getIt(),
        signInWithGoogle: getIt(),
        validator: getIt()));
    getIt.registerFactory(
        () => ForgotPasswordBloc(forgotPassword: getIt(), validator: getIt()));
    getIt.registerFactory(
      () => AuthenticationBloc(
        getCurrentUser: getIt(),
        isFirstAppLaunch: getIt(),
        isUserProfileCreated: getIt(),
        setIsFirstAppLaunchFalse: getIt(),
        signOut: getIt(),
        userStream: getIt(),
      ),
    );

    // use case
    getIt.registerLazySingleton(() => SendEmailVerification(repo: getIt()));
    getIt.registerLazySingleton(() => SignOut(repo: getIt()));
    getIt.registerLazySingleton(() => CreateAccountWithEmail(repo: getIt()));
    getIt.registerLazySingleton(() => CreateUserDocument(repo: getIt()));
    getIt.registerLazySingleton(() => SignInWithEmail(repo: getIt()));
    getIt.registerLazySingleton(() => SignInWithGoogle(repo: getIt()));
    getIt.registerLazySingleton(() => ForgotPassword(repo: getIt()));
    getIt.registerLazySingleton(() => GetCurrentUser(repo: getIt()));
    getIt.registerLazySingleton(() => IsFirstAppLaunch(repo: getIt()));
    getIt.registerLazySingleton(() => SetIsFirstAppLaunchFalse(repo: getIt()));
    getIt.registerLazySingleton(() => UserStream(repo: getIt()));
    getIt.registerLazySingleton(() => IsUserProfileCreated(repo: getIt()));

    // repository
    getIt.registerLazySingleton<AuthenticationRepo>(
      () => AuthenticationRepoImpl(
        auth: getIt(),
        networkInfo: getIt(),
      ),
    );
    getIt.registerLazySingleton<MiscRepo>(
      () => MiscRepoImpl(
        preferences: getIt(),
      ),
    );

    // data source
    getIt.registerLazySingleton<AuthenticationRemote>(
      () => FirebaseAuthService(
        auth: getIt(),
        googleSignIn: getIt(),
        storage: getIt(),
        store: getIt(),
      ),
    );
  }
}
