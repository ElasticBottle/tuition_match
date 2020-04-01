import 'dart:async';

import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:loadany/loadany.dart';

class AssignmentListPage extends StatefulWidget {
  @override
  _AssignmentListPageState createState() => _AssignmentListPageState();
}

class _AssignmentListPageState extends State<AssignmentListPage> {
  LoadStatus status = LoadStatus.normal;
  int loadMoreParam = 10;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        print('refresh assignment list');
        await Future<dynamic>.delayed(Duration(seconds: 1));
        return Future.value(1);
      },
      displacement: SpacingsAndHeights.refreshDisplacement,
      child: LoadAny(
        onLoadMore: () async {
          setState(() {
            status = LoadStatus.loading;
          });
          print('loading more assignments');
          await Future<dynamic>.delayed(Duration(seconds: 1));
          setState(() {
            loadMoreParam = loadMoreParam + 10;
            status = LoadStatus.error;
          });
        },
        endLoadMore: false,
        bottomTriggerDistance: 100,
        footerHeight: 70,
        status: status,
        loadMoreBuilder: (BuildContext context, LoadStatus status) {
          if (status == LoadStatus.loading) {
            return Container(
              height: 70,
              child: CircularProgressIndicator(),
              color: Colors.white,
              alignment: Alignment.center,
            );
          }
          return null;
        },
        child: CustomScrollView(
          slivers: <Widget>[
            ///First sliver is the App Bar
            CustomSliverAppbar(),
            SliverList(
              ///Lazy building of list
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  /// To convert this infinite list to a list with "n" no of items,
                  /// uncomment the following line:
                  if (index > loadMoreParam) {
                    return null;
                  }
                  return listItem(
                      Colors.yellow[600], 'Sliver List item: $index');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget listItem(Color color, String title) => Container(
        height: 100.0,
        color: color,
        child: Center(
          child: Text(
            '$title',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Quicksand'),
          ),
        ),
      );
}

class CustomSliverAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      ///Properties of app bar
      backgroundColor: CustomColorAndFonts.backgroundColor,
      elevation: SpacingsAndHeights.appbarElevation,
      primary: true,
      floating: true,
      snap: false,
      pinned: false,
      centerTitle: false,
      title: Text(
        Strings.assignmentTitle,
        style: TextStyle(
            color: CustomColorAndFonts.primary,
            fontSize: CustomColorAndFonts.fontSizeTitle,
            fontWeight: FontWeight.bold,
            fontFamily: CustomColorAndFonts.primaryFont),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: CustomColorAndFonts.primary,
          ),
          onPressed: () {
            print('search press');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: CustomColorAndFonts.primary,
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
