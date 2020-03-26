import 'package:firebase_auth_demo_flutter/features/onboarding/data/datasources/onboard_info_data_source.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/data/repositories/onboarding_repository_adapter.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/presentation/bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'features/onboarding/domain/repositories/onboarding_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      getOnboardingInfo: sl(),
    ),
  );

  // UseCase
  sl.registerLazySingleton(() => GetOnboardingInfo(repository: sl()));

  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryAdapter(dataSource: sl()));

  // DataSources
  sl.registerLazySingleton<OnboardInfoDataSource>(
      () => OnboardInfoDataSourceImpl(sl()));

  //! Core

  //! External
  sl.registerLazySingleton<AssetBundle>(() => rootBundle);
}
