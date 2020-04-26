import 'package:cotor/common_widgets/information_display/cache_badge.dart';
import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/edit_tutor_profile/bloc/edit_tutor_profile_bloc.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/models/user_model.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/features/view_tutor_profile/helper.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorDetails extends StatelessWidget {
  const TutorDetails({
    @required this.tutorProfileModel,
    this.userDetails,
  });
  final TutorProfileModel tutorProfileModel;
  final UserModel userDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.onPrimary,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  tutorProfileModel.tutorName.toString(),
                  style: Theme.of(context).textTheme.headline6,
                ),
                if (tutorProfileModel.uid == userDetails.uid)
                  BlocBuilder<UserProfileBloc, UserProfileState>(
                    builder: (context, state) {
                      return CacheBadge(
                        hasCacheProfile: state.hasCachedProfile,
                        child: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.edit,
                            color: ColorsAndFonts
                                .userProfilePageEditProfileIconColour,
                          ),
                          onPressed: () {
                            BlocProvider.of<EditTutorProfileBloc>(context).add(
                              InitialiseProfileFields(
                                tutorProfile: tutorProfileModel,
                                userDetails: userDetails,
                                isCacheProfile: state.hasCachedProfile,
                              ),
                            );
                            Navigator.of(context)
                                .pushNamed(Routes.editTutorPage);
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
            InfoDisplay(
              isAnim: true,
              spacingBgColor: Theme.of(context).colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              spacingBetweenFields: 20.0,
              elevation: 2.0,
              icons: [
                FaIcon(
                  FontAwesomeIcons.book,
                ),
                FaIcon(
                  FontAwesomeIcons.school,
                ),
                FaIcon(
                  FontAwesomeIcons.chalkboardTeacher,
                ),
                Icon(
                  Icons.attach_money,
                ),
                Icon(
                  Icons.watch,
                ),
                Icon(
                  Icons.location_on,
                ),
                FaIcon(
                  FontAwesomeIcons.certificate,
                ),
                Icon(
                  Icons.speaker_notes,
                ),
              ],
              title: [
                ...Helper.makeTextTitle([
                  Strings.subject,
                  Strings.levelsTaught,
                  Strings.classFormat,
                  Strings.rate,
                  Strings.timing,
                  Strings.location,
                  Strings.qualifications,
                  Strings.sellingPoints,
                ], context),
              ],
              descriptions: [
                Helper.wrapper(
                  Helper.makeBadges(
                    tutorProfileModel.subjects,
                    ColorsAndFonts.subjectBadgeColor,
                    context,
                  ),
                ),
                Helper.wrapper(
                  Helper.makeBadges(
                    tutorProfileModel.levelsTaught,
                    ColorsAndFonts.levelBadgeColor,
                    context,
                  ),
                ),
                Helper.wrapper(
                  Helper.makeBadges(
                    tutorProfileModel.formats,
                    ColorsAndFonts.classFormatBadgeColor,
                    context,
                  ),
                ),
                Text(
                  Helper.formatPrice(
                    rateMin: tutorProfileModel.rateMin,
                    ratemax: tutorProfileModel.rateMax,
                    rateType: tutorProfileModel.rateType,
                  ),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  tutorProfileModel.timing,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  tutorProfileModel.location,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  tutorProfileModel.qualifications,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  tutorProfileModel.sellingPoints,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
