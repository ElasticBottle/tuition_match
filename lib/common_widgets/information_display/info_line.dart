import 'package:flutter/material.dart';

class InfoLine extends StatelessWidget {
  /// Creates an Info Line similar to ListTile but stripped
  ///
  /// If no title is present, the spacing between the leading and info is the sum
  /// of [spacingIconAndtitle] and [spacingTitleAndInfo]
  const InfoLine({
    Key key,
    this.leading,
    this.title,
    this.info,
    this.infoBgColor = Colors.white,
    this.spacingLeadingAndTitle = 5.0,
    this.spacingTitleAndInfo = 10.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);
  final Widget leading;
  final Widget title;
  final Widget info;
  final Color infoBgColor;
  final double spacingLeadingAndTitle;
  final double spacingTitleAndInfo;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: infoBgColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          leading,
          SizedBox(width: spacingLeadingAndTitle),
          title,
          SizedBox(width: spacingTitleAndInfo),
          Expanded(child: info),
        ],
      ),
    );
  }
}
