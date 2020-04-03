import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      ///Properties of app bar
      backgroundColor: ColorsAndFonts.backgroundColor,
      elevation: SpacingsAndHeights.appbarElevation,
      primary: true,
      floating: true,
      snap: false,
      pinned: false,
      centerTitle: false,
      title: Text(
        Strings.assignmentTitle,
        style: TextStyle(
            color: ColorsAndFonts.primaryColor,
            fontSize: ColorsAndFonts.fontSizeAppbarTitle,
            fontWeight: FontWeight.bold,
            fontFamily: ColorsAndFonts.primaryFont),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: ColorsAndFonts.primaryColor,
          ),
          onPressed: () {
            print('search press');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: ColorsAndFonts.primaryColor,
          ),
          onPressed: () {
            print('favourtie press');
          },
        ),
        Padding(
          padding:
              EdgeInsets.only(right: SpacingsAndHeights.rightAppBarPadding),
        )
      ],
    );
  }
}
