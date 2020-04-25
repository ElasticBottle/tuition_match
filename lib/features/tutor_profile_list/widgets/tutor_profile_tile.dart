import 'package:cotor/common_widgets/information_display/app_badge.dart';
import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/common_widgets/bars/bottom_action_bar.dart';
import 'package:cotor/common_widgets/information_display/user_detail_card.dart';
import 'package:cotor/common_widgets/information_display/avatar.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/tutor_profile_list/helper.dart';
import 'package:cotor/features/view_tutor_profile/bloc/view_tutor_profile_bloc.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorProfileTile extends StatelessWidget {
  const TutorProfileTile({
    this.profile,
    this.cardColor = ColorsAndFonts.backgroundColor,
    this.cardElevation = SpacingsAndHeights.cardElevation,
    this.cardPadding = SpacingsAndHeights.cardPadding,
  });
  final TutorProfileModel profile;
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
            UserDetailCard(
              heroTagForPhoto: profile.uid,
              photoUrl: profile.photoUrl,
              name: profile.tutorName,
              badge: AppBadge(
                badgeColor: Colors.white,
                badgeText: profile.tutorOccupation,
                textStyle: Theme.of(context).textTheme.subtitle2,
              ),
              radius: 18.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            _buildTappableInfoPreview(context, profile),
            SizedBox(
              height: 10.0,
            ),
            BottomActionBar(
              numClickAction: profile.numLiked,
              mainOnPressed: () {},
              actionOnPressed: () {},
              callToActionText: Strings.request,
              numClickCallToAction:
                  profile.numRequest.toString() + Strings.applied,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTappableInfoPreview(
      BuildContext context, TutorProfileModel profile) {
    return InkWell(
      onTap: () {
        print('to show user profile page');
        BlocProvider.of<ViewTutorProfileBloc>(context).add(
          ViewProfile(profile: profile),
        );
        Navigator.of(context).pushNamed(Routes.viewTutorProfilePage);
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: InfoDisplay(
          infoBgColor: ColorsAndFonts.backgroundColor,
          spacingBgColor: ColorsAndFonts.backgroundColor,
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
          ],
          descriptions: [
            Helper.wrapper(
              Helper.makeBadges(
                profile.subjects,
                ColorsAndFonts.subjectBadgeColor,
                context,
              ),
            ),
            Helper.wrapper(
              Helper.makeBadges(
                profile.levelsTaught
                    .map((e) => Helper.shortenLevel(e))
                    .toList(),
                ColorsAndFonts.levelBadgeColor,
                context,
              ),
            ),
            Helper.wrapper(
              Helper.makeBadges(
                profile.formats,
                ColorsAndFonts.classFormatBadgeColor,
                context,
              ),
            )
          ],
          spacingBetweenFields: 15,
        ),
      ),
    );
  }
}
