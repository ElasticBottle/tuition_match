import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/common_widgets/information_display/user_detail_card.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:flutter/material.dart';

class DisplayTile extends StatelessWidget {
  const DisplayTile({
    Key key,
    this.heroTagForPhoto,
    this.photoUrl,
    @required this.name,
    this.nameSubtitle,
    this.badges,
    @required this.onPressed,
    @required this.icons,
    @required this.description,
    @required this.bottomActionBar,
    this.cardColor,
    this.cardElevation,
    this.cardPadding,
  }) : super(key: key);

  // user detail card
  final String heroTagForPhoto;
  final String name;

  /// Url for avatar picture
  final String photoUrl;

  /// widget under user's name
  final Widget nameSubtitle;

  /// Items next to user detail card
  final List<Widget> badges;

  /// Tappable preview callback
  final VoidCallback onPressed;

  /// Tappable preview icons
  final List<Widget> icons;

  /// Tappable preview descriptions
  final List<Widget> description;

  // Bottom Action Bar
  final Widget bottomActionBar;

  // General Details
  final Color cardColor;
  final double cardElevation;
  final double cardPadding;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor ?? Theme.of(context).colorScheme.surface,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(SpacingsAndHeights.cardBevel),
      ),
      elevation: cardElevation ?? 5.0,
      child: Padding(
        padding: EdgeInsets.all(cardPadding ?? 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserDetailCard(
              heroTagForPhoto: heroTagForPhoto,
              photoUrl: photoUrl,
              name: name,
              badge: nameSubtitle,
              radius: 18.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildTappableInfoPreview(context),
            SizedBox(
              height: 10.0,
            ),
            bottomActionBar,
          ],
        ),
      ),
    );
  }

  Widget _buildTappableInfoPreview(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: InfoDisplay(
          infoBgColor: Theme.of(context).colorScheme.surface,
          spacingBgColor: Theme.of(context).colorScheme.surface,
          icons: icons,
          descriptions: description,
          spacingBetweenFields: 15,
        ),
      ),
    );
  }
}
