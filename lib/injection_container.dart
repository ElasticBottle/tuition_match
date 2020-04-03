import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/data/repository_implementations/tutee_assignment_repository_impl.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_cached_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_next_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_tutee_assignment_list.dart';
import 'package:cotor/features/onboarding/data/datasources/onboard_info_data_source.dart';
import 'package:cotor/features/onboarding/data/repositories/onboarding_repository_adapter.dart';
import 'package:cotor/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:cotor/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:cotor/features/onboarding/presentation/bloc/bloc.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/tutee_assginments_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
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

  // UseCase
  sl.registerLazySingleton(() => GetOnboardingInfo(repository: sl()));

  sl.registerLazySingleton(() => GetTuteeAssignmentList(repo: sl()));
  sl.registerLazySingleton(() => GetNextTuteeAssignmentList(repo: sl()));
  sl.registerLazySingleton(() => GetCachedTuteeAssignmentList(repo: sl()));

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryAdapter(dataSource: sl()));
  sl.registerLazySingleton<TuteeAssignmentRepo>(() => TuteeAssignmentRepoImpl(
        localDs: sl(),
        remoteDs: sl(),
        networkInfo: sl(),
      ));

  // DataSources
  sl.registerLazySingleton<OnboardInfoDataSource>(
      () => OnboardInfoDataSourceImpl(sl()));
  sl.registerLazySingleton<TuteeAssignmentRemoteDataSource>(
      () => TuteeAssignmentRemoteDataSourceImpl(remoteStore: sl()));
  sl.registerLazySingleton<TuteeAssignmentLocalDataSource>(
      () => TuteeAssignmentLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<Firestore>(() => Firestore.instance);
  sl.registerLazySingleton(() => DataConnectionChecker());
  sl.registerLazySingleton<AssetBundle>(() => rootBundle);
}
