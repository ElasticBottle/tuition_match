import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/paginated_sliver_list.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/bloc.dart';
import 'package:cotor/features/tutee_assignment_list/widgets/assignment_item_tile.dart';
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
          CustomSliverAppbar(
            title: Strings.assignmentTitle,
          ),
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
                    return PaginatedSliverList<TuteeAssignment>(
                      assignments: state.assignments,
                      loadState: LoadState.loading,
                      builder:
                          (BuildContext context, TuteeAssignment assignment) {
                        return AssignmentItemTile(
                          assignment: assignment,
                        );
                      },
                    );
                  } else if (state is AssignmentLoaded) {
                    return PaginatedSliverList(
                      assignments: state.assignments,
                      builder:
                          (BuildContext context, TuteeAssignment assignment) {
                        return AssignmentItemTile(
                          assignment: assignment,
                        );
                      },
                    );
                  } else if (state is CachedAssignmentLoaded) {
                    return PaginatedSliverList(
                      assignments: state.assignments,
                      builder:
                          (BuildContext context, TuteeAssignment assignment) {
                        return AssignmentItemTile(
                          assignment: assignment,
                        );
                      },
                    );
                  } else if (state is AssignmentError) {
                    BlocProvider.of<AssignmentsBloc>(context)
                        .add(GetCachedAssignmentList());
                    return LoadingWidget();
                  } else if (state is CachedAssignmentError) {
                    // TODO(ElasticBottle): create page with image and message bleow it explaining the error and offer action button if any
                  } else if (state is AllAssignmentLoaded) {
                    return PaginatedSliverList(
                      assignments: state.assignments,
                      loadState: LoadState.allLoaded,
                      builder:
                          (BuildContext context, TuteeAssignment assignment) {
                        return AssignmentItemTile(
                          assignment: assignment,
                        );
                      },
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
