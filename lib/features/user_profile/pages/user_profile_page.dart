import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_display/avatar.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/add_tutee_assignment/bloc/edit_tutee_assignment_bloc.dart';
import 'package:cotor/features/edit_tutor_profile/bloc/edit_tutor_profile_bloc.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/tutee_assignment_list/widgets/assignment_item_tile.dart';
import 'package:cotor/features/user_profile/bloc/user_profile_page_bloc.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EditTutorProfileBloc editTutorProfileBloc =
        BlocProvider.of<EditTutorProfileBloc>(context);
    final UserProfileBloc userProfileBloc =
        BlocProvider.of<UserProfileBloc>(context);
    final EditTuteeAssignmentBloc editTuteeAssignmentBloc =
        BlocProvider.of<EditTuteeAssignmentBloc>(context);
    return CustomScrollView(
      slivers: [
        CustomSliverAppbar(
          title: Strings.yourProfile,
        ),
        BlocBuilder<UserProfilePageBloc, UserProfilePageState>(
          builder: (context, state) {
            return SliverToBoxAdapter(
              child: Column(
                children: [
                  Avatar(
                    photoUrl: state.userModel.photoUrl.isEmpty
                        ? null
                        : state.userModel.photoUrl,
                    radius: MediaQuery.of(context).size.width / 4,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  if (state.userModel.isTutor)
                    TutorDetails(
                      tutorProfileModel: state.userModel.tutorProfile,
                      isEditable: true,
                    ),
                  if (!state.userModel.isTutor)
                    CustomRaisedButton(
                      width: MediaQuery.of(context).size.width / 1.8,
                      onPressed: () {
                        editTutorProfileBloc
                          ..add(
                            InitialiseProfileFields(
                              tutorProfile: TutorProfileModel(),
                              userDetails: userProfileBloc.state.userProfile,
                            ),
                          );
                        Navigator.of(context, rootNavigator: true)
                            .pushNamed(Routes.editTutorPage);
                      },
                      textColor: ColorsAndFonts.backgroundColor,
                      color: ColorsAndFonts.primaryColor,
                      child: Text(Strings.startTeachingNow),
                    ),
                  Divider(
                    height: 50.0,
                    thickness: 5.0,
                  ),
                  Text(Strings.myAssignment)
                ],
              ),
            );
          },
        ),
        BlocBuilder<UserProfilePageBloc, UserProfilePageState>(
          builder: (context, state) {
            final List<TuteeAssignmentModel> assignments =
                state.userModel.userAssignments.values.toList();
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return AssignmentItemTile(
                    assignment: assignments[index],
                  );
                },
                childCount: state.userModel.userAssignments.length,
              ),
            );
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              CustomRaisedButton(
                onPressed: () {
                  editTuteeAssignmentBloc.add(
                    InitialiseEditTuteeFields(
                        assignment: TuteeAssignmentModel(),
                        userDetails: userProfileBloc.state.userProfile),
                  );
                  Navigator.of(context).pushNamed(Routes.editAssignmentPage);
                },
                width: MediaQuery.of(context).size.width / 1.8,
                textColor: ColorsAndFonts.backgroundColor,
                color: ColorsAndFonts.primaryColor,
                child: Text(Strings.addAssignment),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TutorDetails extends StatelessWidget {
  const TutorDetails({
    this.tutorProfileModel,
    this.isEditable,
  });
  final TutorProfileModel tutorProfileModel;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(Strings.bio),
            if (isEditable)
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.edit,
                  color: ColorsAndFonts.userProfilePageEditProfileIconColour,
                ),
                onPressed: () {},
              ),
          ],
        ),
      ],
    );
  }
}
