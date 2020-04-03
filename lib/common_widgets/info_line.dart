import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:flutter/material.dart';

class InfoLine extends StatelessWidget {
  const InfoLine({
    this.icon,
    this.infoText,
  });
  final IconData icon;
  final String infoText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
        ),
        SizedBox(width: SpacingsAndHeights.infoLineIconTextSpacing),
        Text(
          infoText,
          style: TextStyle(
            color: ColorsAndFonts.primaryColor,
            fontFamily: ColorsAndFonts.primaryFont,
          ),
        ),
      ],
    );
  }
}
