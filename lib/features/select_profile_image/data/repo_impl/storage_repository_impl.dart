import 'dart:io';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/platform/is_network_online.dart';
import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/features/select_profile_image/data/datasource/storage_remote_data_source.dart';
import 'package:cotor/features/select_profile_image/domain/repo/storage_repository.dart';
import 'package:dartz/dartz.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl({this.networkInfo, this.storageRemoteDs});

  final NetworkInfo networkInfo;
  final StorageRemoteDataSource storageRemoteDs;

  @override
  Future<Either<Failure, Stream<String>>> uploadImage(String uid, File image) {
    return IsNetworkOnline<Failure, Stream<String>>().call(
      networkInfo: networkInfo,
      ifOffline: NetworkFailure(),
      ifOnline: () async {
        return Right<Failure, Stream<String>>(
            storageRemoteDs.uploadImage(uid, image));
      },
    );
  }
}
