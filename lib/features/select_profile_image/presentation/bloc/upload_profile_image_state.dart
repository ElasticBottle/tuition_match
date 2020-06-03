part of 'upload_profile_image_bloc.dart';

abstract class UploadProfileImageState extends Equatable {
  const UploadProfileImageState();
}

class UploadProfileImageInitial extends UploadProfileImageState {
  @override
  List<Object> get props => [];
}

class UploadProfileImageLoading extends UploadProfileImageState {
  @override
  List<Object> get props => [];
}

class UploadProfileImageInProgress extends UploadProfileImageState {
  const UploadProfileImageInProgress();

  @override
  List<Object> get props => [];
}

class UploadProfileImageDone extends UploadProfileImageState {
  const UploadProfileImageDone({this.msg});
  final String msg;
  @override
  List<Object> get props => [];
}

class UploadProfileImageError extends UploadProfileImageState {
  const UploadProfileImageError({this.msg});
  final String msg;
  @override
  List<Object> get props => [];
}
