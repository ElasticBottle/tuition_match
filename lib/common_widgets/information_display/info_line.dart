import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:flutter/material.dart';

class InfoLine extends StatelessWidget {
  const InfoLine({
    this.icon,
    this.infoText,
    this.spacingBetweenIconAndText = 5.0,
  });
  final IconData icon;
  final String infoText;
  final double spacingBetweenIconAndText;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsAndFonts.backgroundColor,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
          ),
          SizedBox(width: spacingBetweenIconAndText),
          Text(
            infoText,
            style: TextStyle(
                color: ColorsAndFonts.primaryColor,
                fontFamily: ColorsAndFonts.primaryFont,
                fontSize: ColorsAndFonts.addAssignmentSelectionFontSize),
          ),
        ],
      ),
    );
  }
}
