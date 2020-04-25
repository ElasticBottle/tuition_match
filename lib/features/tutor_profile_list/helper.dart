import 'package:cotor/common_widgets/information_display/app_badge.dart';
import 'package:cotor/domain/entities/level.dart';
import 'package:flutter/material.dart';

const String PRESCHOOL_S = 'Pre-Sch';
const String PRI1_S = 'Pri 1';
const String PRI2_S = 'Pri 2';
const String PRI3_S = 'Pri 3';
const String PRI4_S = 'Pri 4';
const String PRI5_S = 'Pri 5';
const String PRI6_S = 'Pri 6';
const String SEC1_S = 'Sec 1';
const String SEC2_S = 'Sec 2';
const String SEC3_S = 'Sec 3';
const String SEC4_S = 'Sec 4';
const String SEC5_S = 'Sec 5';
const String POLY_S = 'Poly';
const String UNI_S = 'Uni';

class Helper {
  static String shortenLevel(String level) {
    switch (level) {
      case Level.PRESCHOOL:
        return PRESCHOOL_S;
      case Level.PRI1:
        return PRI1_S;
      case Level.PRI2:
        return PRI2_S;
      case Level.PRI3:
        return PRI3_S;
      case Level.PRI4:
        return PRI4_S;
      case Level.PRI5:
        return PRI5_S;
      case Level.PRI6:
        return PRI6_S;
      case Level.SEC1:
        return SEC1_S;
      case Level.SEC2:
        return SEC2_S;
      case Level.SEC3:
        return SEC3_S;
      case Level.SEC4:
        return SEC4_S;
      case Level.SEC5:
        return SEC5_S;
      case Level.POLY:
        return POLY_S;
      case Level.UNI:
        return UNI_S;
      default:
        return level;
    }
  }

  static String shortenSubject(String subject) {
    //TODO(ElasticBottle): return shortened subject name

    return '';
  }

  static String formatListString(List<String> toFormat) {
    String toReturn = '';
    final int length = toFormat.length;
    for (int i = 0; i < length; i++) {
      toReturn += toFormat[i];
      if (i != length - 1) {
        toReturn += ' or ';
      }
    }
    return toReturn;
  }

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
}
