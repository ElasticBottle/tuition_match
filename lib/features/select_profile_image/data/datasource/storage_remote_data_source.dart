import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageRemoteDataSource {
  /// Returns a stream indicating percentage of image upload
  Stream<String> uploadImage(String uid, File image);
}

class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  StorageRemoteDataSourceImpl({this.firebaseStorage});
  FirebaseStorage firebaseStorage;
  @override
  Stream<String> uploadImage(String uid, File image) {
    final StorageUploadTask uploadTask =
        firebaseStorage.ref().child('images/' + uid + '.jpg').putFile(image);

    return uploadTask.events.map((event) {
      final double progress =
          event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
      if (uploadTask.isComplete) {
        return '-1';
      }
      return progress.toString();
    });
  }
}
