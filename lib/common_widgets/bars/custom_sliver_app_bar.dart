import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/features/auth_service/auth_service_bloc/auth_service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSliverAppbar extends StatelessWidget {
  const CustomSliverAppbar({
    @required this.title,
    this.showActions = true,
    this.elevation = SpacingsAndHeights.appbarElevation,
    this.bgColor = ColorsAndFonts.backgroundColor,
    this.isFloating = true,
    this.isSnapped = false,
    this.isPinned = false,
    this.isTitleCenter = false,
    this.leading,
  });
  final String title;
  final bool showActions;
  final double elevation;
  final Color bgColor;
  final Widget leading;
  final bool isFloating;
  final bool isPinned;
  final bool isSnapped;
  final bool isTitleCenter;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      ///Properties of app bar
      backgroundColor: bgColor,
      elevation: elevation,
      primary: true,
      floating: isFloating,
      snap: isSnapped,
      pinned: isPinned,
      centerTitle: isTitleCenter,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
            color: ColorsAndFonts.primaryColor,
            fontSize: ColorsAndFonts.fontSizeAppbarTitle,
            fontWeight: FontWeight.bold,
            fontFamily: ColorsAndFonts.primaryFont),
      ),
      actions: showActions
          ? <Widget>[
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
                  BlocProvider.of<AuthServiceBloc>(context).add(LoggedOut());
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: SpacingsAndHeights.rightAppBarPadding),
              )
            ]
          : <Widget>[],
    );
  }
}
