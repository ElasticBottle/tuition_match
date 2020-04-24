import 'package:badges/badges.dart';
import 'package:cotor/common_widgets/information_display/app_badge.dart';
import 'package:cotor/common_widgets/information_display/info_display.dart';
import 'package:cotor/common_widgets/bars/bottom_action_bar.dart';
import 'package:cotor/common_widgets/information_display/user_detail_card.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
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
              photoUrl: profile.photoUrl,
              name: profile.tutorName,
              badge: AppBadge(
                badgeColor: Colors.white,
                badgeText: profile.tutorOccupation,
                textStyle: Theme.of(context).textTheme.subtitle2,
              ),
              heroTagForPhoto: profile.uid,
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
            wrapper(
              makeBadges(
                profile.subjects,
                ColorsAndFonts.subjectBadgeColor,
                context,
              ),
            ),
            wrapper(
              makeBadges(
                profile.levelsTaught,
                ColorsAndFonts.levelBadgeColor,
                context,
              ),
            ),
            wrapper(
              makeBadges(
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

  Widget wrapper(List<Widget> widgets) {
    return Wrap(
      runAlignment: WrapAlignment.start,
      alignment: WrapAlignment.start,
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        ...widgets,
      ],
    );
  }

  List<Widget> makeBadges(
    List<String> items,
    Color badgeColor,
    BuildContext context,
  ) {
    final List<Widget> badges = [];
    for (String item in items) {
      badges.add(
        AppBadge(
          badgeColor: badgeColor,
          badgeText: item,
          textStyle: Theme.of(context).textTheme.subtitle2,
        ),
      );
    }
    return badges;
  }
}
