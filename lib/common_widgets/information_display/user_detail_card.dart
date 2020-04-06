import 'package:cotor/common_widgets/information_display/avatar.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:flutter/material.dart';

class UserDetailCard extends StatelessWidget {
  const UserDetailCard({
    this.photoUrl,
    @required this.tuteeName,
    @required this.username,
    this.timeSinceAdded = '',
  });
  final String photoUrl;
  final Name tuteeName;
  final String username;
  final String timeSinceAdded;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Avatar(
        photoUrl: photoUrl,
        radius: SpacingsAndHeights.userDetailCardAvatarSize,
      ),
      SizedBox(
        width: SpacingsAndHeights.userDetailCardAvatarAndTextSpacing,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tuteeName.toString(),
            style: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
              fontSize: ColorsAndFonts.fontSizeUserDetailCardHead,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                username,
                style: TextStyle(
                  color: ColorsAndFonts.primaryColor,
                  fontFamily: ColorsAndFonts.primaryFont,
                  fontSize: ColorsAndFonts.fontSizeUserDetailCardSubHead,
                ),
              ),
              SizedBox(
                width: SpacingsAndHeights.userDetailCardAvatarAndTextSpacing,
              ),
              if (timeSinceAdded != '')
                Icon(
                  Icons.av_timer,
                  size: 20,
                ),
              if (timeSinceAdded != '')
                Text(
                  timeSinceAdded,
                  style: TextStyle(
                    color: ColorsAndFonts.primaryColor,
                    fontFamily: ColorsAndFonts.primaryFont,
                    fontSize: ColorsAndFonts.fontSizeUserDetailCardSubHead,
                  ),
                ),
            ],
          ),
        ],
      ),
    ]);
  }
}
