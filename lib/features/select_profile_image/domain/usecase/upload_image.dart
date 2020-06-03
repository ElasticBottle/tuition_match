import 'dart:io';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/select_profile_image/domain/repo/storage_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UploadImage extends UseCase<bool, UploadImageParams> {
  UploadImage({this.storageRepo});
  final StorageRepository storageRepo;
  @override
  Future<Either<Failure, bool>> call(UploadImageParams params) async {
    return await storageRepo.uploadImage(params.uid, params.image);
  }
}

class UploadImageParams extends Equatable {
  const UploadImageParams({this.image, this.uid});
  final String uid;
  final File image;

  @override
  List<Object> get props => [image, uid];
}
