import 'package:cotor/common_widgets/information_display/avatar.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:flutter/material.dart';

class UserDetailCard extends StatelessWidget {
  const UserDetailCard(
      {Key key,
      @required this.name,
      this.badge,
      this.photoUrl,
      this.heroTagForPhoto,
      this.timeSinceAdded = '',
      this.radius = 20})
      : super(key: key);
  final String heroTagForPhoto;
  final String photoUrl;
  final Name name;
  final Widget badge;
  final String timeSinceAdded;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Widget avatar = _decideAvatar(photoUrl);
    return Row(children: <Widget>[
      avatar,
      SizedBox(width: 10.0),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name.toString(),
            // style: TextStyle(
            //   color: ColorsAndFonts.primaryColor,
            //   fontFamily: ColorsAndFonts.primaryFont,
            //   fontSize: ColorsAndFonts.fontSizeUserDetailCardHead,
            // ),
          ),
          SizedBox(height: 5),
          if (badge != null) badge,
        ],
      ),
    ]);
  }

  Widget _decideAvatar(String photoUrl) {
    return heroTagForPhoto != null
        ? Hero(
            tag: heroTagForPhoto,
            child: Avatar(
              photoUrl: photoUrl,
              radius: radius,
            ),
          )
        : Avatar(
            photoUrl: photoUrl,
            radius: radius,
          );
  }
}
