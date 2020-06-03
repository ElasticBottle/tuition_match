import 'package:cotor/features/select_profile_image/data/datasource/storage_remote_data_source.dart';
import 'package:cotor/features/select_profile_image/data/repo_impl/storage_repository_impl.dart';
import 'package:cotor/features/select_profile_image/domain/repo/storage_repository.dart';
import 'package:cotor/features/select_profile_image/domain/usecase/upload_image.dart';
import 'package:cotor/features/select_profile_image/presentation/bloc/upload_profile_image_bloc.dart';
import 'package:get_it/get_it.dart';

class SelectProfileImageDependency {
  static void initialize(GetIt getIt) {
    // Bloc
    getIt.registerFactory(() => UploadProfileImageBloc(uploadImage: getIt()));

    // useCase
    getIt.registerLazySingleton(() => UploadImage(storageRepo: getIt()));

    // repository
    getIt.registerLazySingleton<StorageRepository>(
      () =>
          StorageRepositoryImpl(networkInfo: getIt(), storageRemoteDs: getIt()),
    );

    // DataSources
    getIt.registerLazySingleton<StorageRemoteDataSource>(
      () => StorageRemoteDataSourceImpl(firebaseStorage: getIt()),
    );
  }
}
