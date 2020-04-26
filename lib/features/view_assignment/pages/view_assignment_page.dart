import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/bars/bottom_action_bar.dart';
import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignment_list/helper.dart';
import 'package:cotor/features/tutee_assignment_list/widgets/tutee_card_header.dart';
import 'package:cotor/features/view_assignment/bloc/view_assignment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAssignmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsAndFonts.backgroundColor,
      child: Stack(
        overflow: Overflow.clip,
        children: [
          CustomScrollView(
            slivers: [
              CustomSliverAppbar(
                title: Strings.assignment,
                showActions: false,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: ColorsAndFonts.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              BlocBuilder<ViewAssignmentBloc, ViewAssignmentState>(
                bloc: BlocProvider.of<ViewAssignmentBloc>(context),
                builder: (context, state) {
                  final TuteeAssignmentModel assignment = state.assignment;
                  return SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
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
                          InfoDisplay(
                            icons: [
                              Icon(Icons.location_on),
                              Icon(Icons.watch),
                              Icon(Icons.av_timer),
                              Icon(Icons.attach_money),
                              Icon(Icons.perm_identity),
                              Icon(Icons.work),
                              Icon(Icons.speaker_notes),
                            ],
                            descriptions: [
                              Text(assignment.location),
                              Text(assignment.timing),
                              Text(assignment.freq),
                              Text(assignment.rateMin.toString() +
                                  '- ' +
                                  assignment.rateMax.toString()),
                              Text(Helper.formatListString(
                                  assignment.tutorGender)),
                              Text(
                                Helper.formatListString(
                                    assignment.tutorOccupation),
                              ),
                              Text(assignment.additionalRemarks ?? ''),
                            ],
                            spacingBetweenFields: 20.0,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<ViewAssignmentBloc, ViewAssignmentState>(
                builder: (context, state) {
                  final TuteeAssignmentModel assignment = state.assignment;
                  return Padding(
                    padding: EdgeInsets.all(20.0),
                    child: BottomActionBar(
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
                  );
                },
              )),
        ],
      ),
    );
  }
}
