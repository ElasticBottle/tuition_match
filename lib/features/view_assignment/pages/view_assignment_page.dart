import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/bars/bottom_action_bar.dart';
import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/common_widgets/information_display/user_detail_card.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignment_list/widgets/assignment_badge.dart';
import 'package:cotor/features/tutee_assignment_list/widgets/tutee_card_header.dart';
import 'package:cotor/features/view_assignment/bloc/view_assignment_bloc.dart';
import 'package:flutter/foundation.dart';
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
                  final TuteeAssignment assignment = state.assignment;
                  return SliverToBoxAdapter(
                    child: Container(
                      child: Column(
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
                          InfoDisplay(
                            icons: [
                              Icons.location_on,
                              Icons.watch,
                              Icons.av_timer,
                              Icons.attach_money,
                              Icons.perm_identity,
                              Icons.work,
                              Icons.speaker_notes,
                            ],
                            descriptions: [
                              assignment.location,
                              assignment.timing,
                              assignment.freq,
                              assignment.rateMin.toString() +
                                  '- ' +
                                  assignment.rateMax.toString(),
                              describeEnum(assignment.gender),
                              describeEnum(assignment.tutorOccupation),
                              assignment.additionalRemarks,
                            ],
                            tag: assignment.username,
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
                  final TuteeAssignment assignment = state.assignment;
                  return BottomActionBar(
                    heroTag: assignment.username +
                        assignment.subject.toString() +
                        assignment.level.toString(),
                    numClickAction: assignment.liked,
                    mainOnPressed: () {},
                    actionOnPressed: () {},
                    callToActionText: Strings.apply,
                    numClickCallToAction:
                        assignment.applied.toString() + Strings.applied,
                  );
                },
              )),
        ],
      ),
    );
  }
}
