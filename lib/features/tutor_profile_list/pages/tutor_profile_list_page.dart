import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/common_widgets/information_display/display_tile.dart';
import 'package:cotor/common_widgets/information_display/paginated_sliver_list.dart';
import 'package:cotor/common_widgets/information_display/sliver_loading_widget.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/constants/keys.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/tutor_profile_list/bloc/tutor_profile_list_bloc.dart';
import 'package:cotor/features/tutor_profile_list/view_tutor_profile_list_helper.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/features/view_tutor_profile/bloc/view_tutor_profile_bloc.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TutorProfileListPage extends StatefulWidget {
  const TutorProfileListPage({Key key, this.scrollController})
      : super(key: key);

  final ScrollController scrollController;
  @override
  _TutorProfileListPageState createState() => _TutorProfileListPageState();
}

class _TutorProfileListPageState extends State<TutorProfileListPage>
    with AutomaticKeepAliveClientMixin<TutorProfileListPage> {
  ScrollController _scrollController;
  TutorProfileListBloc tutorProfilesBloc;
  UserProfileBloc userProfileBloc;

  void _scrollListener() {
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
    _scrollController = widget.scrollController;
    _scrollController.addListener(_scrollListener);
    tutorProfilesBloc = BlocProvider.of<TutorProfileListBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        tutorProfilesBloc.add(GetTutorProfileList());
      },
      displacement: SpacingsAndHeights.refreshDisplacement,
      child: CustomScrollView(
        key: PageStorageKey<String>(Keys.tutorProfileListPageKey),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          BlocConsumer<TutorProfileListBloc, TutorProfileListState>(
            bloc: tutorProfilesBloc,
            listener: (context, state) {
              if (state is InitialTutorProfilesLoadError) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(CustomSnackBar(
                    toDisplay: Text(state.message),
                  ).show(context));
              } else if (state is TutorProfilesLoaded && state.isCachedList) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(CustomSnackBar(
                    toDisplay: Text(Strings.cachedProfileLoadedMsg),
                  ).show(context));
              } else if (state is TutorProfilesLoaded &&
                  state.isGetNextListError) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(CustomSnackBar(
                    toDisplay: Text(Strings.getNextListError),
                  ).show(context));
              }
            },
            builder: (BuildContext context, TutorProfileListState state) {
              if (state is Loading) {
                return SliverLoadingWidget();
              } else if (state is TutorProfilesLoaded) {
                final LoadState currentLoadState = _getCurrentLoadState(state);
                return PaginatedSliverList(
                  displayItems: state.profiles,
                  loadState: currentLoadState,
                  builder: (BuildContext context, dynamic profile) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 10,
                        vertical: 20,
                      ),
                      child: DisplayTile(
                        cardElevation: 0,
                        heroTagForPhoto: profile.uid,
                        photoUrl: profile.identity.photoUrl,
                        cardPadding: EdgeInsets.all(20),
                        onPressed: () {
                          BlocProvider.of<ViewTutorProfileBloc>(context).add(
                            InitialiseViewTutorProfile(
                                isInNestedScrollView: false,
                                profile: profile,
                                isUser: profile.uid ==
                                    BlocProvider.of<UserProfileBloc>(context)
                                        .state
                                        .userProfile
                                        .identity
                                        .uid),
                          );
                          Navigator.of(context)
                              .pushNamed(Routes.viewTutorProfilePage);
                        },
                        name: profile.name.toString(),
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
                        description: [
                          TutorProfileListUtil.wrapper(
                            TutorProfileListUtil.makeBadges(
                              profile.details.subjectsTaught
                                  .map<String>((dynamic e) => e.toString())
                                  .toList(),
                              ColorsAndFonts.subjectBadgeColor,
                              context,
                            ),
                          ),
                          TutorProfileListUtil.wrapper(
                            TutorProfileListUtil.makeBadges(
                              profile.details.levelsTaught
                                  .map<String>((dynamic e) => e.toString())
                                  .toList(),
                              ColorsAndFonts.levelBadgeColor,
                              context,
                            ),
                          ),
                          TutorProfileListUtil.wrapper(
                            TutorProfileListUtil.makeBadges(
                              profile.requirements.classFormat
                                  .map<String>((dynamic e) => e.toString())
                                  .toList(),
                              ColorsAndFonts.classFormatBadgeColor,
                              context,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              } else if (state is InitialTutorProfilesLoadError &&
                  !state.isCacheError) {
                tutorProfilesBloc.add(GetCachedTutorProfileList());
                return SliverLoadingWidget();
              } else if (state is InitialTutorProfilesLoadError &&
                  state.isCacheError) {
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
