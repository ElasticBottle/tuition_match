import 'package:cotor/common_widgets/information_display/user_detail_card.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/domain/entities/enums.dart';
import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/subject.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'assignment_badge.dart';

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
  final Level level;
  final Subject subject;
  final ClassFormat format;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            UserDetailCard(
              // photoUrl: assignment.userPhoto,
              tuteeName: tuteeName,
              username: username,
              // timeSinceAdded: assignment.timeSinceAdded,
            ),
            SizedBox(
              width: 10.0,
            ),
            AssignmentBadge(
              badgeColor: ColorsAndFonts.levelBadgeColor,
              badgeText: describeEnum(level),
            ),
            AssignmentBadge(
              badgeColor: ColorsAndFonts.subjectBadgeColor,
              badgeText: subject.toString(),
            ),
            AssignmentBadge(
              badgeColor: ColorsAndFonts.classFormatBadgeColor,
              badgeText: describeEnum(format),
            )
            // PopupMenuButton<dynamic>(itemBuilder: null),
          ],
        ),
      ),
    );
  }
}
