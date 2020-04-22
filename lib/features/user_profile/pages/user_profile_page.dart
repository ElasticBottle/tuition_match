import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_display/avatar.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/add_tutee_assignment/bloc/edit_tutee_assignment_bloc.dart';
import 'package:cotor/features/edit_tutor_profile/bloc/edit_tutor_profile_bloc.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/models/user_model.dart';
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
    return BlocListener<UserProfileBloc, UserProfileState>(
      bloc: userProfileBloc,
      listener: (context, state) {
        if (state.updateProfileSuccess) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.check),
                    SizedBox(width: 20.0),
                    Expanded(child: Text(state.updateProfileSuccessMsg))
                  ],
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: Strings.dismiss,
                  onPressed: () {
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                ),
                backgroundColor: Colors.green,
              ),
            );
        }
      },
      child: CustomScrollView(
        slivers: [
          CustomSliverAppbar(
            title: Strings.yourProfile,
          ),
          BlocBuilder<UserProfilePageBloc, UserProfilePageState>(
            bloc: BlocProvider.of<UserProfilePageBloc>(context),
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: Column(
                  children: [
                    Avatar(
                      photoUrl:
                          userProfileBloc.state.userProfile.photoUrl.isEmpty
                              ? null
                              : userProfileBloc.state.userProfile.photoUrl,
                      radius: MediaQuery.of(context).size.width / 4,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (userProfileBloc.state.userProfile.isTutor)
                      TutorDetails(
                        tutorProfileModel:
                            userProfileBloc.state.userProfile.tutorProfile,
                        isEditable: true,
                        editTutorProfileBloc: editTutorProfileBloc,
                        userDetails: userProfileBloc.state.userProfile,
                      ),
                    if (!userProfileBloc.state.userProfile.isTutor)
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
              final List<TuteeAssignmentModel> assignments = userProfileBloc
                  .state.userProfile.userAssignments.values
                  .toList();
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return AssignmentItemTile(
                      assignment: assignments[index],
                    );
                  },
                  childCount:
                      userProfileBloc.state.userProfile.userAssignments.length,
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
      ),
    );
  }
}

class TutorDetails extends StatelessWidget {
  const TutorDetails({
    @required this.tutorProfileModel,
    this.isEditable = false,
    this.editTutorProfileBloc,
    this.userDetails,
  });
  final TutorProfileModel tutorProfileModel;
  final bool isEditable;
  final EditTutorProfileBloc editTutorProfileBloc;
  final UserModel userDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(Strings.bio),
            if (isEditable)
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.edit,
                  color: ColorsAndFonts.userProfilePageEditProfileIconColour,
                ),
                onPressed: () {
                  editTutorProfileBloc
                    ..add(
                      InitialiseProfileFields(
                        tutorProfile: tutorProfileModel,
                        userDetails: userDetails,
                      ),
                    );
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(Routes.editTutorPage);
                },
              ),
          ],
        ),
      ],
    );
  }
}
