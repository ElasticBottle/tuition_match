import 'package:cotor/common_widgets/buttons/custom_raised_button.dart';
import 'package:cotor/common_widgets/information_display/cache_badge.dart';
import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/entities/post/tutor_profile/profile.dart';
import 'package:cotor/features/edit_tutor_profile/bloc/edit_tutor_profile_bloc.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/features/view_tutor_profile/view_tutor_profile_util.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorDetails extends StatelessWidget {
  const TutorDetails({
    @required this.tutorProfile,
    this.isUserProfile,
  });
  final TutorProfile tutorProfile;
  final bool isUserProfile;

  @override
  Widget build(BuildContext context) {
    if (isUserProfile && tutorProfile.identity == null) {
      return BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
        return Column(
          children: [
            Text(
              state.userProfile.identity?.name.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.bold, letterSpacing: -1),
            ),
            SizedBox(height: 20),
            CacheBadge(
              hasCacheProfile: state.hasCachedProfile,
              child: CustomRaisedButton(
                width: MediaQuery.of(context).size.width / 2,
                onPressed: () {
                  BlocProvider.of<EditTutorProfileBloc>(context).add(
                    EditTutorProfileBlocInitialise(
                        tutorProfile: TutorProfile(),
                        userDetails: state.userProfile,
                        isCacheProfile: state.hasCachedProfile),
                  );
                  Navigator.of(context).pushNamed(Routes.editTutorPage);
                },
                child: Text(Strings.startTeachingNow,
                    style: Theme.of(context).textTheme.button),
              ),
            ),
          ],
        );
      });
    } else {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    tutorProfile.identity.name.toString(),
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                  ),
                  if (isUserProfile)
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
                              Scaffold.of(context).hideCurrentSnackBar();
                              BlocProvider.of<EditTutorProfileBloc>(context)
                                  .add(
                                EditTutorProfileBlocInitialise(
                                  tutorProfile: state.userProfile.profile,
                                  userDetails: state.userProfile,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.userTie,
                    size: 17,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(
                    tutorProfile.occupation.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .apply(fontSizeFactor: 1.2),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                ViewTutorProfileUtil.formatPrice(
                  rateMin: tutorProfile.minRate,
                  rateMax: tutorProfile.maxRate,
                  rateType: tutorProfile.rateType.toShortString(),
                ),
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .apply(fontSizeDelta: 2)
                    .copyWith(letterSpacing: -2),
              ),
              SizedBox(height: 20),
              InfoDisplay(
                isAnim: !isUserProfile,
                isDetailedView: true,
                spacingBgColor: Theme.of(context).colorScheme.surface,
                infoBgColor: Theme.of(context).colorScheme.surface,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 10,
                    vertical: 5.0),
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacingBetweenFields: 40.0,
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
                  ...ViewTutorProfileUtil.makeTextTitle([
                    Strings.subjectLabel,
                    Strings.levelsTaughtLabel,
                    Strings.classFormatLabel,
                    Strings.timingLabel,
                    Strings.locationLabel,
                    Strings.qualificationsLabel,
                    Strings.sellingPointsLabel,
                  ], context),
                ],
                descriptions: [
                  ViewTutorProfileUtil.wrapper(
                    ViewTutorProfileUtil.makeBadges(
                      tutorProfile.details.subjectsTaught
                          .map((e) => e.toString())
                          .toList(),
                      ColorsAndFonts.subjectBadgeColor,
                      context,
                    ),
                  ),
                  ViewTutorProfileUtil.wrapper(
                    ViewTutorProfileUtil.makeBadges(
                      tutorProfile.details.levelsTaught
                          .map((e) => e.toString())
                          .toList(),
                      ColorsAndFonts.levelBadgeColor,
                      context,
                    ),
                  ),
                  ViewTutorProfileUtil.wrapper(
                    ViewTutorProfileUtil.makeBadges(
                      tutorProfile.requirements.classFormat
                          .map((e) => e.toString())
                          .toList(),
                      ColorsAndFonts.classFormatBadgeColor,
                      context,
                    ),
                  ),
                  Text(
                    tutorProfile.requirements.timing.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    tutorProfile.requirements.location.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    tutorProfile.details.qualification.toString(),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    tutorProfile.details.sellingPoints.toString(),
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
}
