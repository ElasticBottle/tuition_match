import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/data/datasources/auth_service_remote.dart';
import 'package:cotor/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/data/datasources/user_remote_data_source.dart';
import 'package:cotor/data/repository_implementations/auth_service_repo_impl.dart';
import 'package:cotor/data/repository_implementations/tutee_assignment_repository_impl.dart';
import 'package:cotor/data/repository_implementations/user_repo_impl.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/create_user_profile_for_google_sign_in.dart';
import 'package:cotor/domain/usecases/auth_service/sign_in_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/sign_in_with_goolge.dart';
import 'package:cotor/domain/usecases/auth_service/sign_out.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_cached_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_next_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/user/get_current_user.dart';
import 'package:cotor/domain/usecases/user/get_user_profile.dart';
import 'package:cotor/domain/usecases/user/user_stream.dart';
import 'package:cotor/features/add_tutee_assignment/bloc/add_tutee_assignment_bloc.dart';
import 'package:cotor/features/auth_service/bloc/auth_service_bloc/auth_service_bloc.dart';
import 'package:cotor/features/auth_service/bloc/first_time_google_sign_in/first_time_google_sign_in_bloc.dart';
import 'package:cotor/features/auth_service/bloc/login_bloc/login_bloc.dart';
import 'package:cotor/features/auth_service/bloc/registraiton_bloc/registration_bloc.dart';
import 'package:cotor/features/auth_service/validator.dart';
import 'package:cotor/features/onboarding/data/datasources/onboard_info_data_source.dart';
import 'package:cotor/features/onboarding/data/repositories/onboarding_repository_adapter.dart';
import 'package:cotor/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:cotor/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:cotor/features/onboarding/presentation/bloc/bloc.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/tutee_assginments_bloc.dart';
import 'package:cotor/features/view_assignment/bloc/view_assignment_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      getOnboardingInfo: sl(),
    ),
  );

  sl.registerFactory<AssignmentsBloc>(
    () => AssignmentsBloc(
      getAssignmentList: sl(),
      getNextAssignments: sl(),
      getCachedAssignments: sl(),
    ),
  );

  sl.registerFactory<AddTuteeAssignmentBloc>(
    () => AddTuteeAssignmentBloc(),
  );

  sl.registerFactory<ViewAssignmentBloc>(
    () => ViewAssignmentBloc(),
  );

  sl.registerFactory<AuthServiceBloc>(
    () => AuthServiceBloc(
      userStream: sl(),
      getUserProfile: sl(),
      signOut: sl(),
    ),
  );

  sl.registerFactory<LoginBloc>(
    () => LoginBloc(
      authServiceBloc: sl(),
      getUserProfile: sl(),
      signInWithEmail: sl(),
      signInWithGoogle: sl(),
      validator: sl(),
    ),
  );

  sl.registerFactory<RegistrationBloc>(
    () => RegistrationBloc(
      createAccountWithEmail: sl(),
      validator: sl(),
    ),
  );

  sl.registerFactory<FirstTimeGoogleSignInBloc>(
    () => FirstTimeGoogleSignInBloc(
      createUserProfileForGoogleSignIn: sl(),
      validator: sl(),
    ),
  );
  // UseCase
  sl.registerLazySingleton(() => GetOnboardingInfo(repository: sl()));

  sl.registerLazySingleton(() => GetTuteeAssignmentList(repo: sl()));
  sl.registerLazySingleton(() => GetNextTuteeAssignmentList(repo: sl()));
  sl.registerLazySingleton(() => GetCachedTuteeAssignmentList(repo: sl()));

  sl.registerLazySingleton(() => UserStream(repo: sl()));
  sl.registerLazySingleton(() => GetCurrentUser(repo: sl()));
  sl.registerLazySingleton(() => GetUserProfile(repo: sl()));
  sl.registerLazySingleton(() => CreateAccountWithEmail(repo: sl()));
  sl.registerLazySingleton(() => CreateUserProfileForGoogleSignIn(repo: sl()));
  sl.registerLazySingleton(() => SignInWithEmail(repo: sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(repo: sl()));
  sl.registerLazySingleton(() => SignOut(repo: sl()));

  sl.registerLazySingleton(() => EmailAndPasswordValidators());

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryAdapter(dataSource: sl()));
  sl.registerLazySingleton<TuteeAssignmentRepo>(() => TuteeAssignmentRepoImpl(
        userDs: sl(),
        localDs: sl(),
        remoteDs: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<UserRepo>(() => UserRepoImpl(
        networkInfo: sl(),
        userDs: sl(),
      ));
  sl.registerLazySingleton<AuthServiceRepo>(
    () => AuthServiceRepoImpl(
      auth: sl(),
      networkInfo: sl(),
      userRepo: sl(),
    ),
  );

  // DataSources
  sl.registerLazySingleton<OnboardInfoDataSource>(
      () => OnboardInfoDataSourceImpl(sl()));
  sl.registerLazySingleton<TuteeAssignmentRemoteDataSource>(
      () => TuteeAssignmentRemoteDataSourceImpl(remoteStore: sl()));
  sl.registerLazySingleton<TuteeAssignmentLocalDataSource>(
      () => TuteeAssignmentLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => FirestoreUserDataSource(
      auth: sl(),
      store: sl(),
    ),
  );
  sl.registerLazySingleton<AuthServiceRemote>(
    () => FirebaseAuthService(
      auth: sl(),
      googleSignIn: sl(),
      store: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<Firestore>(() => Firestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton<AssetBundle>(() => rootBundle);
}
