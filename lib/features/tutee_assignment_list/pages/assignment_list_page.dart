import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/information_display/sliver_loading_widget.dart';
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
  final ScrollController _scrollController = ScrollController();
  AssignmentsBloc assignmentsBloc;

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      final AssignmentsState currentState = assignmentsBloc.state;
      if (currentState is AssignmentLoaded && !currentState.isEnd) {
        assignmentsBloc.add(GetNextAssignmentList());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    assignmentsBloc = BlocProvider.of<AssignmentsBloc>(context);
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        print('refresh assignment list');
        assignmentsBloc.add(GetAssignmentList());
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
          BlocConsumer<AssignmentsBloc, AssignmentsState>(
            bloc: assignmentsBloc,
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
                      assignmentsBloc.add(GetAssignmentList());
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
              if (state is AssignmentLoaded && state.isCachedList) {
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
            builder: (BuildContext context, AssignmentsState state) {
              if (state is Loading) {
                return SliverLoadingWidget();
              } else if (state is AssignmentLoaded) {
                final LoadState currentLoadState = _getCurrentLoadState(state);
                return PaginatedSliverList<TuteeAssignment>(
                  displayItems: state.assignments,
                  loadState: currentLoadState,
                  builder: (BuildContext context, TuteeAssignment assignment) {
                    return AssignmentItemTile(
                      assignment: assignment,
                    );
                  },
                );
              } else if (state is AssignmentError) {
                assignmentsBloc.add(GetCachedAssignmentList());
                return SliverLoadingWidget();
              } else if (state is CachedAssignmentError) {
                // TODO(ElasticBottle): create page with image and message bleow it explaining the error and offer action button if any
              }
              // TODO(ElasticBottle): replace widget below with page containing image and message explainging unknonwn happening and offer action button if any
              return SliverToBoxAdapter(
                child: Container(
                  color: Colors.red,
                ),
              );
            },
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

  LoadState _getCurrentLoadState(AssignmentLoaded state) {
    if (state.isFetching) {
      return LoadState.loading;
    } else if (state.isEnd) {
      return LoadState.allLoaded;
    } else {
      return LoadState.normal;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
