import 'package:flutter/material.dart';

class InfoLine extends StatelessWidget {
  /// Creates an Info Line similar to ListTile but stripped
  ///
  /// If no title is present, the spacing between the leading and info is the sum
  /// of [spacingIconAndtitle] and [spacingTitleAndInfo]
  const InfoLine({
    Key key,
    @required this.leading,
    this.title = const SizedBox(width: 0),
    @required this.info,
    this.elevation = 10,
    this.infoBgColor = Colors.white,
    this.spacingLeadingAndTitle = 5.0,
    this.spacingTitleAndInfo = 10.0,
    this.padding = const EdgeInsets.all(10.0),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);
  final Widget leading;
  final Widget title;
  final Widget info;
  final Color infoBgColor;
  final double elevation;
  final double spacingLeadingAndTitle;
  final double spacingTitleAndInfo;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: infoBgColor,
      elevation: elevation,
      child: Padding(
        padding: padding,
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
      ),
    );
  }
}
