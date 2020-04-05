import 'package:cotor/common_widgets/info_line.dart';
import 'package:cotor/common_widgets/user_detail_card.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignment_list/widgets/assignment_badge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AssignmentItemTile extends StatelessWidget {
  const AssignmentItemTile({
    this.assignment,
    this.cardColor = ColorsAndFonts.backgroundColor,
    this.cardElevation = SpacingsAndHeights.cardElevation,
    this.cardPadding = SpacingsAndHeights.cardPadding,
  });
  final TuteeAssignment assignment;
  final Color cardColor;
  final double cardElevation;
  final double cardPadding;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(SpacingsAndHeights.cardBevel),
      ),
      elevation: cardElevation,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCardHeader(),
            SizedBox(
              height: 10.0,
            ),
            _buildTappableInfoPreview(context),
            SizedBox(
              height: 10.0,
            ),
            _buildCardFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        UserDetailCard(
          // photoUrl: assignment.userPhoto,
          tuteeName: assignment.tuteeName,
          username: assignment.username,
          // timeSinceAdded: assignment.timeSinceAdded,
        ),
        SizedBox(
          width: 10.0,
        ),
        AssignmentBadge(
          badgeColor: ColorsAndFonts.levelBadgeColor,
          badgeText: describeEnum(assignment.level),
        ),
        AssignmentBadge(
          badgeColor: ColorsAndFonts.subjectBadgeColor,
          badgeText: assignment.subject.toString(),
        ),
        AssignmentBadge(
          badgeColor: ColorsAndFonts.classFormatBadgeColor,
          badgeText: describeEnum(assignment.format),
        )
        // PopupMenuButton<dynamic>(itemBuilder: null),
      ],
    );
  }

  Widget _buildTappableInfoPreview(BuildContext context) {
    return InkWell(
      onTap: () {
        print('card tapped');
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            InfoLine(icon: Icons.timer, infoText: assignment.timing),
            SizedBox(height: SpacingsAndHeights.assignmentItemTileInfoSpacing),
            InfoLine(icon: Icons.location_on, infoText: assignment.location),
            SizedBox(height: SpacingsAndHeights.assignmentItemTileInfoSpacing),
            InfoLine(
                icon: Icons.radio_button_checked, infoText: assignment.freq),
            SizedBox(height: SpacingsAndHeights.assignmentItemTileInfoSpacing),
            InfoLine(
                icon: Icons.attach_money,
                infoText: assignment.rateMin.toString() +
                    '- ' +
                    assignment.rateMax.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFooter() {
    return Row(
      children: <Widget>[
        Expanded(
          child: FlatButton(
            color: ColorsAndFonts.primaryColor,
            child: const Text('Apply',
                style: TextStyle(color: ColorsAndFonts.backgroundColor)),
            onPressed: () {
              print('apply pressed');
            },
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: ColorsAndFonts.primaryColor,
            size: SpacingsAndHeights.bottomBarIconSize,
          ),
          onPressed: () {
            print('liked pressed');
          },
        ),
        Text(
          assignment.liked.toString(),
          style: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont),
        ),
      ],
    );
  }
}
