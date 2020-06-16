import 'package:cotor/common_widgets/information_display/avatar.dart';
import 'package:flutter/material.dart';

class ProfilePictureDisplay extends StatelessWidget {
  const ProfilePictureDisplay({
    this.showAddProfilePicButton = false,
    this.photoUrl = '',
    String heroTag = '',
    this.radius = 50,
    this.topSpacing = 20,
    this.onAddProfilePicPressed,
  }) : heroTagForPhoto = heroTag ?? '';
  final bool showAddProfilePicButton;
  final String photoUrl;
  final String heroTagForPhoto;
  final double radius;
  final double topSpacing;
  final VoidCallback onAddProfilePicPressed;
  @override
  Widget build(BuildContext context) {
    final Avatar avatar = Avatar(
      photoUrl: photoUrl,
      radius: radius,
    );
    return Container(
      color: Theme.of(context).colorScheme.background,
      width: MediaQuery.of(context).size.width,
      height: radius * 2 + topSpacing,
      child: Stack(
        children: [
          Positioned(
            top: radius + topSpacing,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: radius,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
          ),
          Positioned(
            top: topSpacing,
            left: MediaQuery.of(context).size.width / 2 - radius,
            child: heroTagForPhoto.isEmpty
                ? avatar
                : Hero(
                    tag: heroTagForPhoto,
                    child: avatar,
                  ),
          ),
          if (showAddProfilePicButton)
            Positioned(
              top: radius * 2 - topSpacing,
              left: MediaQuery.of(context).size.width / 2 + radius * 0.75,
              child: IconButton(
                icon: Icon(
                  Icons.camera_enhance,
                ),
                onPressed: onAddProfilePicPressed,
              ),
            ),
        ],
      ),
    );
  }
}
