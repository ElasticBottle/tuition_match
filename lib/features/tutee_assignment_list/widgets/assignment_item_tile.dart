import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/common_widgets/bars/bottom_action_bar.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/view_assignment/bloc/view_assignment_bloc.dart';
import 'package:cotor/features/tutee_assignment_list/widgets/tutee_card_header.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            TuteeCardHeader(
              heroTag: assignment.username +
                  assignment.subject.toString() +
                  assignment.level.toString() +
                  assignment.dateAdded,
              tuteeName: assignment.tuteeName,
              username: assignment.username,
              level: assignment.level,
              subject: assignment.subject,
              format: assignment.format,
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildTappableInfoPreview(context, assignment),
            SizedBox(
              height: 10.0,
            ),
            BottomActionBar(
              heroTag: assignment.username +
                  assignment.subject.toString() +
                  assignment.level.toString(),
              numClickAction: assignment.liked,
              mainOnPressed: () {},
              actionOnPressed: () {},
              callToActionText: Strings.apply,
              numClickCallToAction:
                  assignment.applied.toString() + Strings.applied,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTappableInfoPreview(
      BuildContext context, TuteeAssignment assignment) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ViewAssignmentBloc>(context)
            .add(AssignmentToView(assignment: assignment));
        Navigator.of(context, rootNavigator: true)
            .pushNamed(Routes.viewAssignmentpage);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: InfoDisplay(
          tag: assignment.username,
          icons: [
            Icons.location_on,
            Icons.watch,
            Icons.av_timer,
            Icons.attach_money
          ],
          descriptions: [
            assignment.location,
            assignment.timing,
            assignment.freq,
            assignment.rateMin.toString() + '- ' + assignment.rateMax.toString()
          ],
          spacingBetweenFields:
              SpacingsAndHeights.assignmentItemTileInfoSpacing,
        ),
      ),
    );
  }
}
