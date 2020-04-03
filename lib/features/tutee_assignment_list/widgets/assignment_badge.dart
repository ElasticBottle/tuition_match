import 'package:badges/badges.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:flutter/material.dart';

class AssignmentBadge extends StatelessWidget {
  const AssignmentBadge({
    this.badgeColor,
    this.badgeText,
  });
  final Color badgeColor;
  final String badgeText;
  @override
  Widget build(BuildContext context) {
    return Badge(
      badgeColor: badgeColor,
      shape: BadgeShape.square,
      borderRadius: SpacingsAndHeights.assignmentBadgeRadius,
      toAnimate: false,
      padding: EdgeInsets.symmetric(
          horizontal: SpacingsAndHeights.assignmentBadgeHorPadding,
          vertical: SpacingsAndHeights.assignmentBadgeVertPadding),
      badgeContent: Text(
        badgeText,
        style: TextStyle(
            color: ColorsAndFonts.primaryColor,
            fontFamily: ColorsAndFonts.primaryFont),
      ),
    );
  }
}
