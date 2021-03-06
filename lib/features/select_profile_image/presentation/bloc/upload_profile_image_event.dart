part of 'upload_profile_image_bloc.dart';

abstract class UploadProfileImageEvent extends Equatable {
  const UploadProfileImageEvent();
}

class UploadProfileImageStartUpload extends UploadProfileImageEvent {
  const UploadProfileImageStartUpload({
    this.uid,
    this.image,
  });
  final String uid;
  final File image;
  @override
  List<Object> get props => [image, uid];
}
