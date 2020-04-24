import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    @required this.badgeColor,
    @required this.badgeText,
    @required this.textStyle,
    this.badgeRadius = 10.0,
    this.horPadding = 10.0,
    this.vertPadding = 5.0,
  });
  final Color badgeColor;
  final String badgeText;
  final double badgeRadius;
  final double horPadding;
  final double vertPadding;
  final TextStyle textStyle;
  @override
  Widget build(BuildContext context) {
    return Badge(
      toAnimate: false,
      shape: BadgeShape.square,
      borderRadius: badgeRadius,
      badgeColor: badgeColor,
      padding: EdgeInsets.symmetric(
        horizontal: horPadding,
        vertical: vertPadding,
      ),
      badgeContent: Text(
        badgeText,
        style: textStyle,
      ),
    );
  }
}
