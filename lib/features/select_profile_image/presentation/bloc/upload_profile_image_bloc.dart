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
    } else if (event is UploadProfileImageErrorOccurred) {
      yield* _mapUploadProfileImageErrorOccurredToState(event.msg);
    } else if (event is UploadProfileImageProgress) {
      yield* _mapUploadProfileImageProgressToState(event.progress);
    }
  }

  Stream<UploadProfileImageState> _mapUploadProfileImageStartUploadToState(
      File image, String uid) async* {
    uploadStatus?.cancel();
    yield UploadProfileImageLoading();
    if (image != null) {
      final Either<Failure, Stream<String>> result =
          await uploadImage(UploadImageParams(image: image, uid: uid));
      yield* result.fold(
        (l) async* {
          yield UploadProfileImageError(msg: Strings.networkFailureErrorMsg);
        },
        (r) async* {
          uploadStatus = r.listen(
            (event) {
              add(UploadProfileImageProgress(progress: event));
            },
            onError: (Object error) {
              add(UploadProfileImageErrorOccurred(msg: 'Something went wrong'));
              uploadStatus?.cancel();
            },
          );
        },
      );
    } else {
      yield UploadProfileImageError(
          msg: 'Please choose an new image to upload!');
    }
  }

  Stream<UploadProfileImageState> _mapUploadProfileImageErrorOccurredToState(
      String msg) async* {
    yield UploadProfileImageError(msg: msg);
  }

  Stream<UploadProfileImageState> _mapUploadProfileImageProgressToState(
      String progress) async* {
    yield UploadProfileImageInProgress();
    if (progress == '-1') {
      yield UploadProfileImageDone(msg: 'successfully updated profile picture');
    }
  }
}
