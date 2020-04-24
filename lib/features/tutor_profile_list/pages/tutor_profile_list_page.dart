import 'package:cotor/common_widgets/bars/custom_sliver_app_bar.dart';
import 'package:cotor/common_widgets/information_display/sliver_loading_widget.dart';
import 'package:cotor/common_widgets/paginated_sliver_list.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/tutor_profile_list/bloc/tutor_profile_list_bloc.dart';
import 'package:cotor/features/tutor_profile_list/widgets/tutor_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TutorProfileListPage extends StatefulWidget {
  const TutorProfileListPage({Key key}) : super(key: key);
  @override
  _TutorProfileListPageState createState() => _TutorProfileListPageState();
}

class _TutorProfileListPageState extends State<TutorProfileListPage>
    with AutomaticKeepAliveClientMixin<TutorProfileListPage> {
  final ScrollController _scrollController = ScrollController();
  TutorProfileListBloc tutorProfilesBloc;

  void _scrollListener() {
    print('listening');
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      final TutorProfileListState _currentState = tutorProfilesBloc.state;
      if (_currentState is TutorProfilesLoaded && !_currentState.isEnd) {
        tutorProfilesBloc.add(GetNextTutorProfileList());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tutorProfilesBloc = BlocProvider.of<TutorProfileListBloc>(context);
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        print('refresh profile list');
        tutorProfilesBloc.add(GetTutorProfileList());
      },
      displacement: SpacingsAndHeights.refreshDisplacement,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: <Widget>[
          CustomSliverAppbar(
            title: Strings.tutorProfileTitle,
          ),
          BlocConsumer<TutorProfileListBloc, TutorProfileListState>(
            bloc: tutorProfilesBloc,
            listener: (context, state) {
              if (state is TutorProfilesError) {
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
              if (state is TutorProfilesLoaded && state.isCachedList) {
                _displaySnacBar(
                  context: context,
                  message: Strings.cachedProfileLoadedMsg,
                  action: SnackBarAction(
                    label: 'dismiss',
                    textColor: ColorsAndFonts.secondaryColor,
                    onPressed: Scaffold.of(context).hideCurrentSnackBar,
                  ),
                );
              }
              if (state is TutorProfilesLoaded && state.isGetNextListError) {
                _displaySnacBar(
                  context: context,
                  message: Strings.getNextListError,
                  action: SnackBarAction(
                    label: 'dismiss',
                    textColor: ColorsAndFonts.secondaryColor,
                    onPressed: Scaffold.of(context).hideCurrentSnackBar,
                  ),
                );
              }
            },
            builder: (BuildContext context, TutorProfileListState state) {
              if (state is Loading) {
                return SliverLoadingWidget();
              } else if (state is TutorProfilesLoaded) {
                final LoadState currentLoadState = _getCurrentLoadState(state);
                return PaginatedSliverList<TutorProfileModel>(
                  displayItems: state.profiles,
                  loadState: currentLoadState,
                  builder: (BuildContext context, TutorProfileModel profile) {
                    return TutorProfileTile(
                      profile: profile,
                    );
                  },
                );
              } else if (state is TutorProfilesError) {
                tutorProfilesBloc.add(GetCachedTutorProfileList());
                return SliverLoadingWidget();
              } else if (state is TutorProfilesError) {
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

  LoadState _getCurrentLoadState(TutorProfilesLoaded state) {
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
