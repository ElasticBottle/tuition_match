import 'dart:async';
import 'dart:io';
import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_display/avatar.dart';
import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/features/select_profile_image/presentation/bloc/upload_profile_image_bloc.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class SelectProfileImagePage extends StatefulWidget {
  @override
  _SelectProfileImagePageState createState() => _SelectProfileImagePageState();
}

class _SelectProfileImagePageState extends State<SelectProfileImagePage> {
  File _image;
  UploadProfileImageBloc uploadProfileImageBloc;
  UserProfileBloc userProfileBloc;

  @override
  void initState() {
    super.initState();
    uploadProfileImageBloc = BlocProvider.of<UploadProfileImageBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
  }

  Future<File> getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery
    final PickedFile image = await ImagePicker().getImage(source: source);

    //Cropping the image
    if (image != null) {
      final File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        maxWidth: 256,
        maxHeight: 256,
      );

      if (croppedFile != null) {
        //Compress the image
        final Directory dir = await path_provider.getTemporaryDirectory();
        final String targetPath = dir.absolute.path + '/temp.jpg';
        final File result = await FlutterImageCompress.compressAndGetFile(
          croppedFile.absolute.path,
          targetPath,
          quality: 50,
        );
        setState(() {
          _image = croppedFile;
        });
        return result;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Upload profile Picture',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        body: BlocListener<UploadProfileImageBloc, UploadProfileImageState>(
          listener: (context, state) {
            if (state is UploadProfileImageError) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  CustomSnackBar(
                    toDisplay: Text(
                      state.msg,
                    ),
                  ).show(context),
                );
            } else if (state is UploadProfileImageDone) {
              Navigator.of(context).pop();
              userProfileBloc.add(UpdateProfileSuccess(state.msg));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: _image == null
                    ? Avatar(
                        radius: 100,
                        photoUrl: userProfileBloc
                            .state.userProfile.identity?.photoUrl,
                      )
                    : Image.file(
                        _image,
                        height: 200,
                        width: 200,
                      ),
              ),
              Spacer(),
              _uploadPictureButton(),
              Spacer(),
            ],
          ),
        ),
        floatingActionButton: _cameraFloatingActionButton());
  }

  Widget _uploadPictureButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CustomRaisedButton(
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: BlocBuilder<UploadProfileImageBloc, UploadProfileImageState>(
          builder: (context, state) {
            if (state is UploadProfileImageLoading) {
              return CircularProgressIndicator();
            }
            return Text('Save Profile Picture');
          },
        ),
        onPressed: () {
          uploadProfileImageBloc.add(UploadProfileImageStartUpload(
            image: _image,
            uid: userProfileBloc.state.userProfile.identity?.uid,
          ));
        },
      ),
    );
  }

  Widget _cameraFloatingActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton.extended(
          label: Text('Camera'),
          heroTag: null,
          onPressed: () => getImageFile(ImageSource.camera),
          icon: Icon(Icons.camera),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        SizedBox(
          width: 20,
        ),
        FloatingActionButton.extended(
          label: Text('Gallery'),
          heroTag: null,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          onPressed: () => getImageFile(ImageSource.gallery),
          icon: Icon(Icons.photo_library),
        )
      ],
    );
  }
}
