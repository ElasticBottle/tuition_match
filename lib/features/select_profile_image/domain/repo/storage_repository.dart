import 'dart:io';

import 'package:cotor/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class StorageRepository {
  /// Pushes an image to cloud storage
  ///
  /// All fields should be provided
  ///
  /// Returns a stream indicating the progress of photo upload
  ///
  /// Failure is one of:
  /// * __[NetworkFailure]__ when called without internet access on user's device
  Future<Either<Failure, bool>> uploadImage(String uid, File image);
}
