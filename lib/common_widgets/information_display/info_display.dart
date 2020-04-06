import 'package:flutter/material.dart';

import 'info_line.dart';

class InfoDisplay extends StatelessWidget {
  const InfoDisplay({
    @required this.icons,
    @required this.descriptions,
    this.spacingBetweenFields = 10.0,
    this.tag,
  }) : assert(icons.length == descriptions.length);
  final List<IconData> icons;
  final List<String> descriptions;
  final double spacingBetweenFields;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (int index = 0; index < icons.length; index++) {
      children.add(
        Hero(
          tag: '$tag' '$index',
          child:
              InfoLine(icon: icons[index], infoText: descriptions[index] ?? ''),
        ),
      );
      children.add(SizedBox(height: spacingBetweenFields));
    }
    return Column(
      children: <Widget>[
        ...children,
      ],
    );
  }
}
