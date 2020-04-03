import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentListPage extends StatefulWidget {
  const AssignmentListPage({Key key}) : super(key: key);
  @override
  _AssignmentListPageState createState() => _AssignmentListPageState();
}

class _AssignmentListPageState extends State<AssignmentListPage> {
  int loadMoreParam = 10;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        print('refresh assignment list');
        await Future<dynamic>.delayed(Duration(milliseconds: 50));
        BlocProvider.of<AssignmentsBloc>(context).add(GetAssignmentList());
      },
      displacement: SpacingsAndHeights.refreshDisplacement,
      child: CustomScrollView(
        slivers: <Widget>[
          ///First sliver is the App Bar
          CustomSliverAppbar(),
          BlocListener<AssignmentsBloc, AssignmentsState>(
            bloc: BlocProvider.of<AssignmentsBloc>(context),
            listener: (context, state) {
              SnackBar snackBar;
              // if (state is AssignmentError) {
              //   snackBar = SnackBar(
              //     content: Text(state.message),
              //     action: SnackBarAction(
              //       label: 'Refresh',
              //       onPressed: () {
              //         // Some code to undo the change.
              //       },
              //     ),
              //   );
              // } else if (state is NextAssignmentError) {
              //   snackBar = SnackBar(
              //     content: Text(state.message),
              //     action: SnackBarAction(
              //       label: 'Refresh',
              //       onPressed: () {
              //         // Some code to undo the change.
              //       },
              //     ),
              //   );
              if (state is CachedAssignmentError) {
                snackBar = SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.only(
                        bottom: SpacingsAndHeights.bottomSnacBarTextPadding),
                    child: Text(
                      state.message,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: ColorsAndFonts.primaryFont,
                          fontSize: ColorsAndFonts.fontSizeSnacBarMsg),
                    ),
                  ),
                  action: SnackBarAction(
                    label: 'Refresh',
                    onPressed:
                        // Some code to undo the change.
                        Scaffold.of(context).hideCurrentSnackBar,
                  ),
                  duration: Duration(seconds: 3),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              }
              if (state is CachedAssignmentLoaded) {
                snackBar = SnackBar(
                  content: Padding(
                    padding: const EdgeInsets.only(
                        bottom: SpacingsAndHeights.bottomSnacBarTextPadding),
                    child: Text(
                      'Currently having issues with server, last retrieved copy loaded',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: ColorsAndFonts.primaryFont,
                          fontSize: ColorsAndFonts.fontSizeSnacBarMsg),
                    ),
                  ),
                  action: SnackBarAction(
                    label: 'dismiss',
                    onPressed:
                        // Some code to undo the change.
                        Scaffold.of(context).hideCurrentSnackBar,
                  ),
                  duration: Duration(seconds: 3),
                );
                Scaffold.of(context).showSnackBar(snackBar);
              }
            },
            child: BlocBuilder<AssignmentsBloc, AssignmentsState>(
                bloc: BlocProvider.of<AssignmentsBloc>(context),
                builder: (BuildContext context, AssignmentsState state) {
                  if (state is InitialAssignmentsState) {
                    BlocProvider.of<AssignmentsBloc>(context)
                        .add(GetAssignmentList());
                  } else if (state is CachedAssignmentLoading ||
                      state is NextAssignmentLoading ||
                      state is AssignmentLoading) {
                    return LoadingWidget();
                  } else if (state is AssignmentLoaded) {
                    return AssignmentsListDisplay(
                        assignments: state.assignments);
                  } else if (state is NextAssignmentLoaded) {
                    return AssignmentsListDisplay(
                        assignments: state.assignments);
                  } else if (state is CachedAssignmentLoaded) {
                    return AssignmentsListDisplay(
                        assignments: state.assignments);
                  }
                  return SliverToBoxAdapter(
                    child: Container(
                      color: Colors.red,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class AssignmentsListDisplay extends StatelessWidget {
  const AssignmentsListDisplay({
    Key key,
    @required this.assignments,
  })  : assert(assignments != null),
        super(key: key);

  final List<TuteeAssignment> assignments;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      ///Lazy building of list
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          /// To convert this infinite list to a list with "n" no of items,
          /// uncomment the following line:
          if (index >= assignments.length && index < assignments.length + 1) {
            // BlocProvider.of<AssignmentsBloc>(context)
            //     .add(GetNextAssignmentList());
            return LoadingWidget.noSliver(context);
          } else if (index >= assignments.length + 1) {
            return null;
          }
          return ItemTile(assignment: assignments[index]);
        },
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({this.assignment});
  final TuteeAssignment assignment;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsAndFonts.backgroundColor,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(SpacingsAndHeights.cardBevel),
      ),
      elevation: SpacingsAndHeights.cardElevation,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.perm_identity, size: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(assignment.tuteeName.toString(),
                        style: TextStyle(
                            color: ColorsAndFonts.primaryColor,
                            fontFamily: ColorsAndFonts.primaryFont,
                            fontSize: ColorsAndFonts.fontSizeSnacBarMsg)),
                    Text(assignment.username,
                        style: TextStyle(
                            color: ColorsAndFonts.primaryColor,
                            fontFamily: ColorsAndFonts.primaryFont,
                            fontSize: 10.0)),
                  ],
                ),
                SizedBox(
                  width: 10.0,
                ),
                Badge(
                  badgeColor: Colors.yellow,
                  shape: BadgeShape.square,
                  borderRadius: 10,
                  toAnimate: false,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  badgeContent: Text(
                    describeEnum(assignment.level),
                    style: TextStyle(
                        color: ColorsAndFonts.primaryColor,
                        fontFamily: ColorsAndFonts.primaryFont),
                  ),
                ),
                Badge(
                  badgeColor: Colors.blue,
                  shape: BadgeShape.square,
                  borderRadius: 10,
                  toAnimate: false,
                  badgeContent: Text(
                    assignment.subject.toString(),
                    style: TextStyle(
                        color: ColorsAndFonts.primaryColor,
                        fontFamily: ColorsAndFonts.primaryFont),
                  ),
                ),
                Badge(
                  badgeColor: Colors.green,
                  shape: BadgeShape.square,
                  borderRadius: 10,
                  toAnimate: false,
                  badgeContent: Text(
                    describeEnum(assignment.format),
                    style: TextStyle(
                        color: ColorsAndFonts.primaryColor,
                        fontFamily: ColorsAndFonts.primaryFont),
                  ),
                ),
                // PopupMenuButton<dynamic>(itemBuilder: null),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: () {
                print('card tapped');
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Timing: ' +
                      assignment.timing +
                      '\n' +
                      'Location: ' +
                      assignment.location +
                      '\n' +
                      'Frequency: ' +
                      assignment.freq +
                      '\nRate: ' +
                      assignment.rateMin.toString() +
                      '- ' +
                      assignment.rateMax.toString() +
                      ' /hour',
                  style: TextStyle(
                    color: ColorsAndFonts.primaryColor,
                    fontFamily: ColorsAndFonts.primaryFont,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    color: ColorsAndFonts.primaryColor,
                    child: const Text('Apply',
                        style:
                            TextStyle(color: ColorsAndFonts.backgroundColor)),
                    onPressed: () {
                      print('apply pressed');
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: ColorsAndFonts.primaryColor,
                    size: SpacingsAndHeights.bottomBarIconSize,
                  ),
                  onPressed: () {
                    print('liked pressed');
                  },
                ),
                Text(
                  assignment.liked.toString(),
                  style: TextStyle(
                      color: ColorsAndFonts.primaryColor,
                      fontFamily: ColorsAndFonts.primaryFont),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  static Widget noSliver(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

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
