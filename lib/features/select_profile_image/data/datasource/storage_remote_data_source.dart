import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/data/datasources/firestore_path.dart';
import 'package:cotor/core/data/models/map_key_strings.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

abstract class StorageRemoteDataSource {
  /// Returns a bool indicating status of image upload
  ///
  /// Throws ServerException for all errors
  Future<bool> uploadImage(String uid, File image);
}

class StorageRemoteDataSourceImpl implements StorageRemoteDataSource {
  StorageRemoteDataSourceImpl({
    @required this.firebaseStorage,
    @required this.store,
  });
  FirebaseStorage firebaseStorage;
  Firestore store;

  @override
  Future<bool> uploadImage(String uid, File image) async {
    final StorageUploadTask uploadTask =
        firebaseStorage.ref().child('images/' + uid + '.jpg').putFile(image);

    final StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    final dynamic downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isSuccessful) {
      final String url = downloadUrl.toString();
      try {
        await store.runTransaction((Transaction tx) async {
          final DocumentReference userProf =
              store.document(FirestorePath.users(uid));
          final DocumentSnapshot userProfileSnapshot = await tx.get(userProf);
          final Map<String, dynamic> toUpdate = userProfileSnapshot.data;
          toUpdate[IDENTITY][PHOTO_URL] = url;
          tx.update(userProf, toUpdate);
        });
        return true;
      } catch (e, stacktrace) {
        print(e.toString() + ' ' + stacktrace.toString());
        throw ServerException();
      }
    } else if (uploadTask.isComplete) {
      // complete but not successful. Something went wrong
      throw ServerException();
    }
    throw ServerException();
  }
}
