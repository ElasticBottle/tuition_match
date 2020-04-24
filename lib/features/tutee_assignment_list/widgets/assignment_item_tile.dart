import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/common_widgets/bars/bottom_action_bar.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
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
  final TuteeAssignmentModel assignment;
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
              heroTag: assignment.uid +
                  assignment.subjects.toString() +
                  assignment.levels.toString() +
                  assignment.dateAdded,
              tuteeName: assignment.tuteeName,
              username: assignment.uid,
              level: assignment.levels,
              subject: assignment.subjects,
              format: assignment.formats,
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildTappableInfoPreview(context, assignment),
            SizedBox(
              height: 10.0,
            ),
            BottomActionBar(
              heroTag: assignment.uid +
                  assignment.subjects.toString() +
                  assignment.levels.toString(),
              numClickAction: assignment.numLiked,
              mainOnPressed: () {},
              actionOnPressed: () {},
              callToActionText: Strings.apply,
              numClickCallToAction:
                  assignment.numApplied.toString() + Strings.applied,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTappableInfoPreview(
      BuildContext context, TuteeAssignmentModel assignment) {
    return InkWell(
      onTap: () {
        BlocProvider.of<ViewAssignmentBloc>(context)
            .add(AssignmentToView(assignment: assignment));
        Navigator.of(context).pushNamed(Routes.viewAssignmentpage);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: InfoDisplay(
          icons: [
            Icon(Icons.location_on),
            Icon(Icons.watch),
            Icon(Icons.av_timer),
            Icon(Icons.attach_money),
          ],
          descriptions: [
            Text(assignment.location),
            Text(assignment.timing),
            Text(assignment.freq),
            Text(
              assignment.rateMin.toString() +
                  '- ' +
                  assignment.rateMax.toString(),
            ),
          ],
          spacingBetweenFields:
              SpacingsAndHeights.assignmentItemTileInfoSpacing,
        ),
      ),
    );
  }
}
