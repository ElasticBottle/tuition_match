import 'package:cotor/common_widgets/animation/fade_in.dart';
import 'package:flutter/material.dart';

import 'info_line.dart';

class InfoDisplay extends StatelessWidget {
  const InfoDisplay({
    Key key,
    @required this.icons,
    @required this.descriptions,
    this.title,
    this.infoBgColor = Colors.white,
    this.spacingBgColor = Colors.white,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.all(5.0),
    this.spacingTitleAndInfo = 10.0,
    this.spacingLeadingAndTitle = 5.0,
    this.spacingBetweenFields = 5.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.isAnim = false,
  })  : assert(icons.length == descriptions.length),
        super(key: key);
  final List<Widget> icons;
  final List<Widget> descriptions;
  final List<Widget> title;
  final Color infoBgColor;
  final Color spacingBgColor;
  final double spacingLeadingAndTitle;
  final double spacingTitleAndInfo;
  final double spacingBetweenFields;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isAnim;
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (int index = 0; index < icons.length; index++) {
      final InfoLine line = InfoLine(
        leading: icons[index],
        title: title == null ? SizedBox(width: 0) : title[index],
        info: descriptions[index] ?? Text(''),
        infoBgColor: infoBgColor,
        spacingLeadingAndTitle: spacingLeadingAndTitle,
        spacingTitleAndInfo: spacingTitleAndInfo,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        elevation: elevation,
        padding: padding,
      );
      if (isAnim) {
        children.add(FadeIn(index + 0.5, line));
      } else {
        children.add(line);
      }
      children.add(SizedBox(height: spacingBetweenFields));
    }
    return Container(
      color: spacingBgColor,
      child: Column(
        children: <Widget>[
          ...children,
        ],
      ),
    );
  }
}
