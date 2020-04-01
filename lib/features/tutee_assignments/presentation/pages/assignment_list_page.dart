import 'dart:async';

import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignments/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loadany/loadany.dart';

class AssignmentListPage extends StatefulWidget {
  const AssignmentListPage({Key key}) : super(key: key);
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
                  } else if (state is CachedAssignmentLoaded) {}
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
          // if (index > loadMoreParam) {
          //   return null;
          // }
          return listItem(Colors.yellow[600], 'Sliver List item: $index');
        },
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
            color: ColorsAndFonts.primary,
            fontSize: ColorsAndFonts.fontSizeAppbarTitle,
            fontWeight: FontWeight.bold,
            fontFamily: ColorsAndFonts.primaryFont),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: ColorsAndFonts.primary,
          ),
          onPressed: () {
            print('search press');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: ColorsAndFonts.primary,
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
