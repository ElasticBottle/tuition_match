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

class _AssignmentListPageState extends State<AssignmentListPage>
    with AutomaticKeepAliveClientMixin<AssignmentListPage> {
  int loadMoreParam = 10;
  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print('at the end of list');
      if (BlocProvider.of<AssignmentsBloc>(context).state
          is! AllAssignmentLoaded) {
        BlocProvider.of<AssignmentsBloc>(context).add(GetNextAssignmentList());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssignmentsBloc>(context).add(GetAssignmentList());
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        print('refresh assignment list');
        BlocProvider.of<AssignmentsBloc>(context).add(GetAssignmentList());
      },
      displacement: SpacingsAndHeights.refreshDisplacement,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: <Widget>[
          ///First sliver is the App Bar
          CustomSliverAppbar(),
          BlocListener<AssignmentsBloc, AssignmentsState>(
            bloc: BlocProvider.of<AssignmentsBloc>(context),
            listener: (context, state) {
              if (state is CachedAssignmentError) {
                // TODO(ElasticBottle): remove when error page is done up for this state
                _displaySnacBar(
                  message: state.message,
                  context: context,
                  action: SnackBarAction(
                    label: 'Refresh',
                    textColor: ColorsAndFonts.secondaryColor,
                    onPressed: () {
                      BlocProvider.of<AssignmentsBloc>(context)
                          .add(GetAssignmentList());
                    },
                  ),
                );
              }
              if (state is AssignmentError) {
                _displaySnacBar(
                  context: context,
                  message: state.message,
                  action: SnackBarAction(
                    label: 'dismiss',
                    textColor: ColorsAndFonts.secondaryColor,
                    onPressed: Scaffold.of(context).hideCurrentSnackBar,
                  ),
                );
              }
              if (state is CachedAssignmentLoaded) {
                _displaySnacBar(
                  context: context,
                  message: Strings.cachedAssignmentLoadedMsg,
                  action: SnackBarAction(
                    label: 'dismiss',
                    textColor: ColorsAndFonts.secondaryColor,
                    onPressed: Scaffold.of(context).hideCurrentSnackBar,
                  ),
                );
              }
            },
            child: BlocBuilder<AssignmentsBloc, AssignmentsState>(
                bloc: BlocProvider.of<AssignmentsBloc>(context),
                builder: (BuildContext context, AssignmentsState state) {
                  if (state is AssignmentLoading) {
                    return LoadingWidget();
                  } else if (state is NextAssignmentLoading) {
                    return AssignmentsListDisplay(
                      assignments: state.assignments,
                      loadState: LoadState.loading,
                    );
                  } else if (state is AssignmentLoaded) {
                    return AssignmentsListDisplay(
                      assignments: state.assignments,
                    );
                  } else if (state is CachedAssignmentLoaded) {
                    return AssignmentsListDisplay(
                      assignments: state.assignments,
                    );
                  } else if (state is AssignmentError) {
                    BlocProvider.of<AssignmentsBloc>(context)
                        .add(GetCachedAssignmentList());
                    return LoadingWidget();
                  } else if (state is CachedAssignmentError) {
                    // TODO(ElasticBottle): create page with image and message bleow it explaining the error and offer action button if any
                  } else if (state is AllAssignmentLoaded) {
                    return AssignmentsListDisplay(
                      assignments: state.assignments,
                      loadState: LoadState.allLoaded,
                    );
                  }
                  // TODO(ElasticBottle): replace widget below with page containing image and message explainging unknonwn happening and offer action button if any
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

  void _displaySnacBar(
      {BuildContext context,
      String message,
      SnackBarAction action,
      int duration = 3}) {
    final SnackBar snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.only(
            bottom: SpacingsAndHeights.bottomSnacBarTextPadding),
        child: Text(
          message,
          style: TextStyle(
              color: Colors.white,
              fontFamily: ColorsAndFonts.primaryFont,
              fontSize: ColorsAndFonts.fontSizeSnacBarMsg),
        ),
      ),
      action: action,
      duration: Duration(seconds: duration),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  bool get wantKeepAlive => true;
}

enum LoadState {
  normal,
  loading,
  allLoaded,
}

class AssignmentsListDisplay extends StatelessWidget {
  const AssignmentsListDisplay({
    Key key,
    @required this.assignments,
    this.loadState = LoadState.normal,
  })  : assert(assignments != null),
        super(key: key);

  final List<TuteeAssignment> assignments;
  final LoadState loadState;
  @override
  Widget build(BuildContext context) {
    return SliverList(
      ///Lazy building of list
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == assignments.length) {
            switch (loadState) {
              case LoadState.normal:
                return EndTile();
                break;
              case LoadState.loading:
                return EndTile(loadState: LoadState.loading);
                break;
              case LoadState.allLoaded:
                return EndTile(loadState: LoadState.allLoaded);
                break;
            }
          } else if (index >= assignments.length) {
            return null;
          }
          return ItemTile(assignment: assignments[index]);
        },
      ),
    );
  }
}

class EndTile extends StatelessWidget {
  const EndTile({this.loadState = LoadState.normal});
  final LoadState loadState;
  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (loadState) {
      case LoadState.normal:
        child = null;
        break;
      case LoadState.loading:
        child = Center(
          child: CircularProgressIndicator(),
        );
        break;
      case LoadState.allLoaded:
        child = Center(
          child: Text(
            Strings.endTileAllItemLoaded,
            style: TextStyle(
              color: ColorsAndFonts.primaryColor,
              fontFamily: ColorsAndFonts.primaryFont,
            ),
          ),
        );
        break;
    }
    return Container(
      height: MediaQuery.of(context).size.height / 7,
      child: child,
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
              height: 400.0,
            ),
            InkWell(
              onTap: () {
                print('card tapped');
              },
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      InfoLine(icon: Icons.timer, infoText: assignment.timing),
                      SizedBox(height: SpacingsAndHeights.itemTileInfoSpacing),
                      InfoLine(
                          icon: Icons.location_on,
                          infoText: assignment.location),
                      SizedBox(height: SpacingsAndHeights.itemTileInfoSpacing),
                      InfoLine(
                          icon: Icons.radio_button_checked,
                          infoText: assignment.freq),
                      SizedBox(height: SpacingsAndHeights.itemTileInfoSpacing),
                      InfoLine(
                          icon: Icons.attach_money,
                          infoText: assignment.rateMin.toString() +
                              '- ' +
                              assignment.rateMax.toString()),
                    ],
                  )),
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

class InfoLine extends StatelessWidget {
  const InfoLine({
    this.icon,
    this.infoText,
  });
  final IconData icon;
  final String infoText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
        ),
        SizedBox(width: SpacingsAndHeights.infoLineIconTextSpacing),
        Text(
          infoText,
          style: TextStyle(
            color: ColorsAndFonts.primaryColor,
            fontFamily: ColorsAndFonts.primaryFont,
          ),
        ),
      ],
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
