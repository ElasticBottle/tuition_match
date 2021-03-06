import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/data/datasources/auth_service_remote.dart';
import 'package:cotor/data/datasources/tutee_assignments/tutee_assignment_local_data_source.dart';
import 'package:cotor/data/datasources/tutee_assignments/tutee_assignment_remote_data_source.dart';
import 'package:cotor/data/datasources/tutor_profiles/tutor_profile_local_data_sourc.dart';
import 'package:cotor/data/datasources/tutor_profiles/tutor_profile_remote_data_source.dart';
import 'package:cotor/data/datasources/user/user_local_data_source.dart';
import 'package:cotor/data/datasources/user/user_remote_data_source.dart';
import 'package:cotor/data/repository_implementations/auth_service_repo_impl.dart';
import 'package:cotor/data/repository_implementations/misc_repo_impl.dart';
import 'package:cotor/data/repository_implementations/tutee_assignment_repository_impl.dart';
import 'package:cotor/data/repository_implementations/tutor_profile_repo_impl.dart';
import 'package:cotor/data/repository_implementations/user_repo_impl.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:cotor/domain/repositories/misc_repo.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/domain/repositories/tutor_profile_repo.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/get_current_user.dart';
import 'package:cotor/domain/usecases/auth_service/send_email_verification.dart';
import 'package:cotor/domain/usecases/auth_service/sign_in_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/sign_in_with_goolge.dart';
import 'package:cotor/domain/usecases/auth_service/sign_out.dart';
import 'package:cotor/domain/usecases/auth_service/user_stream.dart';
import 'package:cotor/domain/usecases/is_first_app_launch.dart';
import 'package:cotor/domain/usecases/set_is_first_app_launch_false.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_cached_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_next_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_cached_tutor_list.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_next_tutor_list.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_tutor_list.dart';
import 'package:cotor/domain/usecases/user/manage_assignments/set_tutee_assignment.dart';
import 'package:cotor/domain/usecases/user/manage_assignments/update_tutee_assignment.dart';
import 'package:cotor/domain/usecases/user/manage_profile/cache_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/manage_profile/get_cache_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/manage_profile/set_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/manage_profile/update_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/request/reqeust_stream.dart';
import 'package:cotor/domain/usecases/user/request/request_tutor_profile.dart';
import 'package:cotor/domain/usecases/user/user_info/create_user_document.dart';
import 'package:cotor/domain/usecases/user/user_info/get_user_profile.dart';
import 'package:cotor/domain/usecases/user/user_info/user_profile_stream.dart';
import 'package:cotor/features/Request/request_bloc/request_bloc.dart';
import 'package:cotor/features/auth_service/auth_service_bloc/auth_service_bloc.dart';
import 'package:cotor/features/auth_service/login/bloc/login_bloc.dart';
import 'package:cotor/features/auth_service/registration/bloc/registration_bloc.dart';
import 'package:cotor/features/auth_service/verify_email/bloc/verify_email_bloc.dart';
import 'package:cotor/features/authentication/authentication.dart';
import 'package:cotor/features/edit_tutee_assignment/bloc/edit_tutee_assignment_bloc.dart';
import 'package:cotor/features/edit_tutor_profile/bloc/edit_tutor_profile_bloc.dart';
import 'package:cotor/features/onboarding/data/datasources/onboard_info_data_source.dart';
import 'package:cotor/features/onboarding/data/repositories/onboarding_repository_adapter.dart';
import 'package:cotor/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:cotor/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:cotor/features/onboarding/presentation/bloc/bloc.dart';
import 'package:cotor/features/request_tutor/request_tutor_form/bloc/request_tutor_form_bloc.dart';
import 'package:cotor/features/request_tutor/select_existing_assignment/bloc/select_existing_assignment_bloc.dart';
import 'package:cotor/features/select_profile_image/select_profile_image_export.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/tutee_assignments_bloc.dart';
import 'package:cotor/features/user_profile/bloc/user_profile_page_bloc.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/features/view_assignment/bloc/view_assignment_bloc.dart';
import 'package:cotor/features/tutor_profile_list/bloc/tutor_profile_list_bloc.dart';
import 'package:cotor/features/view_tutor_profile/bloc/view_tutor_profile_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  SelectProfileImageDependency.initialize(sl);
  AuthenticationDependency.initialise(sl);

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

  sl.registerFactory<EditTuteeAssignmentBloc>(
    () => EditTuteeAssignmentBloc(
      setTuteeAssignment: sl(),
      updateTuteeAssignment: sl(),
      validator: sl(),
    ),
  );

  sl.registerFactory<ViewAssignmentBloc>(
    () => ViewAssignmentBloc(),
  );

  //

  // user data bloc
  sl.registerFactory<UserProfileBloc>(
    () => UserProfileBloc(
      userProfileStream: sl(),
    ),
  );

  // Edit Profile Bloc
  sl.registerFactory<EditTutorProfileBloc>(
    () => EditTutorProfileBloc(
      setTutorProfile: sl(),
      updateTutorProfile: sl(),
      cacheTutorProfile: sl(),
      getCacheTutorProfile: sl(),
      validator: sl(),
    ),
  );

  // Tutor Profile List bloc
  sl.registerFactory<TutorProfileListBloc>(
    () => TutorProfileListBloc(
      getCachedTutorProfileList: sl(),
      getNextTutorProfileList: sl(),
      getTutorProfileList: sl(),
    ),
  );
  // View Tutor List Bloc
  sl.registerFactory<ViewTutorProfileBloc>(() => ViewTutorProfileBloc());

  // Request Tutor Bloc
  sl.registerFactory<RequestTutorFormBloc>(
    () => RequestTutorFormBloc(
      validator: sl(),
      requestTutorProfile: sl(),
    ),
  );
  // Select Existing Assignment Bloc
  sl.registerFactory<SelectExistingAssignmentBloc>(
    () => SelectExistingAssignmentBloc(),
  );

  // User Profile Bloc
  sl.registerFactory(() => UserProfilePageBloc());

  sl.registerFactory(() => RequestBloc(
        requestStream: sl(),
        userProfileStream: sl(),
      ));

  // UseCase
  sl.registerLazySingleton(() => GetOnboardingInfo(repository: sl()));

  sl.registerLazySingleton(() => GetTuteeAssignmentList(repo: sl()));
  sl.registerLazySingleton(() => GetNextTuteeAssignmentList(repo: sl()));
  sl.registerLazySingleton(() => GetCachedTuteeAssignmentList(repo: sl()));

  sl.registerLazySingleton(() => GetTutorList(repo: sl()));
  sl.registerLazySingleton(() => GetNextTutorList(repo: sl()));
  sl.registerLazySingleton(() => GetCachedTutorList(repo: sl()));

  sl.registerLazySingleton(() => UserStream(repo: sl()));
  // sl.registerLazySingleton(() => GetCurrentUser(repo: sl()));
  // sl.registerLazySingleton(() => GetUserProfile(repo: sl()));
  // sl.registerLazySingleton(
  //     () => CreateAccountWithEmail(repo: sl(), createUserDocument: sl()));
  // sl.registerLazySingleton(
  //     () => CreateUserDocument(authServiceRepo: sl(), userRepo: sl()));
  // sl.registerLazySingleton(() => SendEmailVerification(repo: sl()));
  // sl.registerLazySingleton(() => SignInWithEmail(repo: sl()));
  // sl.registerLazySingleton(() => SignInWithGoogle(repo: sl()));
  // sl.registerLazySingleton(() => SignOut(repo: sl()));

  // sl.registerLazySingleton(() => IsFirstAppLaunch(repo: sl()));
  // sl.registerLazySingleton(() => SetIsFirstAppLaunchFalse(repo: sl()));

  sl.registerLazySingleton(() => UserProfileStream(repo: sl()));

  sl.registerLazySingleton(() => SetTutorProfile(repo: sl()));
  sl.registerLazySingleton(() => UpdateTutorProfile(repo: sl()));
  sl.registerLazySingleton(() => GetCacheTutorProfile(tutorProfileRepo: sl()));
  sl.registerLazySingleton(() => CacheTutorProfile(tutorProfileRepo: sl()));

  sl.registerLazySingleton(() => SetTuteeAssignment(repo: sl()));
  sl.registerLazySingleton(() => UpdateTuteeAssignment(repo: sl()));

  sl.registerLazySingleton(() => RequestTutorProfile(userRepo: sl()));
  sl.registerLazySingleton(() => RequestStream(userRepo: sl()));
  // sl.registerLazySingleton(()=>);

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryAdapter(dataSource: sl()));
  sl.registerLazySingleton<TuteeAssignmentRepo>(() => TuteeAssignmentRepoImpl(
        localDs: sl(),
        remoteDs: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<TutorProfileRepo>(
    () => TutorProfileRepoImpl(
      remoteDs: sl(),
      localDs: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<UserRepo>(() => UserRepoImpl(
        localDs: sl(),
        networkInfo: sl(),
        userDs: sl(),
      ));
  // sl.registerLazySingleton<AuthServiceRepo>(
  //   () => AuthServiceRepoImpl(
  //     auth: sl(),
  //     networkInfo: sl(),
  //   ),
  // );
  // sl.registerLazySingleton<MiscRepo>(
  //   () => MiscRepoImpl(
  //     preferences: sl(),
  //   ),
  // );

  // DataSources
  sl.registerLazySingleton<OnboardInfoDataSource>(
      () => OnboardInfoDataSourceImpl(sl()));
  sl.registerLazySingleton<TuteeAssignmentRemoteDataSource>(
      () => TuteeAssignmentRemoteDataSourceImpl(remoteStore: sl()));
  sl.registerLazySingleton<TuteeAssignmentLocalDataSource>(
      () => TuteeAssignmentLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<TutorProfileRemoteDataSource>(
      () => TutorProfileRemoteDataSourceImpl(remoteStore: sl()));
  sl.registerLazySingleton<TutorProfileLocalDataSource>(
      () => TutorProfileLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => FirestoreUserDataSource(
      auth: sl(),
      store: sl(),
      storage: sl(),
    ),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  // sl.registerLazySingleton<AuthServiceRemote>(
  //   () => FirebaseAuthService(
  //     auth: sl(),
  //     googleSignIn: sl(),
  //     store: sl(),
  //   ),
  // );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => EmailAndPasswordValidators());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<Firestore>(() => Firestore.instance);
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
  sl.registerLazySingleton<FirebaseStorage>(
      () => FirebaseStorage(storageBucket: 'gs://tuition-matcher.appspot.com'));
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton<AssetBundle>(() => rootBundle);
}
