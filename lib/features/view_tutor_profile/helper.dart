import 'package:cotor/common_widgets/information_display/app_badge.dart';
import 'package:flutter/material.dart';

class Helper {
  static Widget wrapper(List<Widget> widgets) {
    return Wrap(
      runAlignment: WrapAlignment.start,
      alignment: WrapAlignment.start,
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        ...widgets,
      ],
    );
  }

  static List<Widget> makeBadges(
    List<String> items,
    Color badgeColor,
    BuildContext context,
  ) {
    final List<Widget> badges = [];
    for (String item in items) {
      badges.add(
        AppBadge(
          badgeColor: badgeColor,
          badgeText: item,
          textStyle: Theme.of(context).textTheme.subtitle2,
        ),
      );
    }
    return badges;
  }

  static String formatPrice({double rateMin, double ratemax, String rateType}) {
    return '\$$rateMin - \$$rateMin \/$rateType';
  }

  static List<Widget> makeTextTitle(List<String> list, BuildContext context) {
    final List<Widget> toReturn = [];
    for (String title in list) {
      toReturn.add(
          Text(title + ': ', style: Theme.of(context).textTheme.subtitle1));
    }
    return toReturn;
  }
}
