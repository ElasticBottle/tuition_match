import 'package:flutter/material.dart';

import 'info_line.dart';

class InfoDisplay extends StatelessWidget {
  const InfoDisplay({
    Key key,
    @required this.icons,
    @required this.descriptions,
    this.title,
    this.infoBgColor = Colors.white,
    this.spacingBgColor = Colors.white70,
    this.spacingTitleAndInfo = 10.0,
    this.spacingLeadingAndTitle = 5.0,
    this.spacingBetweenFields = 5.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
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
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (int index = 0; index < icons.length; index++) {
      children.add(
        InfoLine(
          leading: icons[index],
          title: title == null ? SizedBox() : title[index],
          info: descriptions[index] ?? Text(''),
          infoBgColor: infoBgColor,
          spacingLeadingAndTitle: spacingLeadingAndTitle,
          spacingTitleAndInfo: spacingTitleAndInfo,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
        ),
      );
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
