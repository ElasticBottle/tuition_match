import 'package:cotor/common_widgets/information_display/app_badge.dart';
import 'package:cotor/common_widgets/information_display/user_detail_card.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/features/tutee_assignment_list/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TuteeCardHeader extends StatelessWidget {
  const TuteeCardHeader({
    @required this.heroTag,
    @required this.tuteeName,
    @required this.username,
    @required this.level,
    @required this.subject,
    @required this.format,
  });
  final String heroTag;
  final Name tuteeName;
  final String username;
  final List<String> level;
  final List<String> subject;
  final List<String> format;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            UserDetailCard(
              // photoUrl: assignment.userPhoto,
              name: tuteeName,
              // timeSinceAdded: assignment.timeSinceAdded,
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              children: <Widget>[
                for (String lvl in level)
                  AppBadge(
                    badgeColor: ColorsAndFonts.levelBadgeColor,
                    badgeText: Helper.shortenLevel(lvl),
                    textStyle: Theme.of(context).textTheme.subtitle2,
                  ),
              ],
            ),
            Column(
              children: <Widget>[
                for (String subj in subject)
                  AppBadge(
                    badgeColor: ColorsAndFonts.subjectBadgeColor,
                    badgeText: subj,
                    textStyle: Theme.of(context).textTheme.subtitle2,
                  ),
              ],
            ),
            Column(
              children: <Widget>[
                for (String frmt in format)
                  AppBadge(
                    badgeColor: ColorsAndFonts.classFormatBadgeColor,
                    badgeText: frmt,
                    textStyle: Theme.of(context).textTheme.subtitle2,
                  ),
              ],
            )
            // PopupMenuButton<dynamic>(itemBuilder: null),
          ],
        ),
      ),
    );
  }
}
