import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/select_profile_image/domain/usecase/upload_image.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'upload_profile_image_event.dart';
part 'upload_profile_image_state.dart';

class UploadProfileImageBloc
    extends Bloc<UploadProfileImageEvent, UploadProfileImageState> {
  UploadProfileImageBloc({this.uploadImage});
  final UploadImage uploadImage;
  StreamSubscription uploadStatus;

  @override
  Future<void> close() async {
    super.close();
    uploadStatus?.cancel();
  }

  @override
  UploadProfileImageState get initialState => UploadProfileImageInitial();

  @override
  Stream<UploadProfileImageState> mapEventToState(
    UploadProfileImageEvent event,
  ) async* {
    if (event is UploadProfileImageStartUpload) {
      yield* _mapUploadProfileImageStartUploadToState(event.image, event.uid);
    }
  }

  Stream<UploadProfileImageState> _mapUploadProfileImageStartUploadToState(
      File image, String uid) async* {
    uploadStatus?.cancel();
    yield UploadProfileImageLoading();
    if (image != null) {
      final Either<Failure, bool> result =
          await uploadImage(UploadImageParams(image: image, uid: uid));
      yield* result.fold(
        (l) async* {
          if (l is NetworkFailure) {
            yield UploadProfileImageError(msg: Strings.networkFailureErrorMsg);
          } else {
            yield UploadProfileImageError(msg: Strings.serverFailureErrorMsg);
          }
        },
        (r) async* {
          yield UploadProfileImageDone(
            msg: 'successfully updated profile picture',
          );
        },
      );
    } else {
      yield UploadProfileImageError(
          msg: 'Please choose an new image to upload!');
    }
  }
}
