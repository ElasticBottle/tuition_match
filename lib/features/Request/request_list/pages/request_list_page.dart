import 'package:cotor/common_widgets/bars/custom_app_bar.dart';
import 'package:cotor/common_widgets/information_display/custom_snack_bar.dart';
import 'package:cotor/common_widgets/information_display/display_tile.dart';
import 'package:cotor/common_widgets/information_display/paginated_sliver_list.dart';
import 'package:cotor/constants/custom_color_and_fonts.dart';
import 'package:cotor/features/Request/request_bloc/request_bloc.dart';
import 'package:cotor/features/tutor_profile_list/view_tutor_profile_list_helper.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/features/view_tutor_profile/bloc/view_tutor_profile_bloc.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({Key key}) : super(key: key);

  @override
  RequestListPageState createState() => RequestListPageState();
}

class RequestListPageState extends State<RequestListPage> {
  final ScrollController _scrollController = ScrollController();
  RequestBloc requestBloc;
  UserProfileBloc userProfileBloc;

  // void _scrollListener() {
  //   if (_scrollController.offset >=
  //           _scrollController.position.maxScrollExtent &&
  //       !_scrollController.position.outOfRange) {
  //     final TutorProfileListState _currentState = requestBloc.state;
  //     if (_currentState is TutorProfilesLoaded && !_currentState.isEnd) {
  //       requestBloc.add(GetNextTutorProfileList());
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_scrollListener);
    requestBloc = BlocProvider.of<RequestBloc>(context);
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future<dynamic>.delayed(Duration(milliseconds: 500));
          requestBloc.add(RequestLoadNewRequest());
          // requestBloc.add(Request());
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            CustomAppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  requestBloc.add(RequestForId(id: ''));
                  Navigator.of(context).pop();
                },
              ),
            ),
            BlocConsumer<RequestBloc, RequestState>(
              bloc: requestBloc,
              listener: (context, state) {
                if (state.isNewRequestAvailable) {
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      CustomSnackBar(
                        toDisplay: Text('New Reqeust available'),
                      ).show(context),
                    );
                }
              },
              builder: (BuildContext context, RequestState state) {
                return PaginatedSliverList(
                  displayItems: state.requests[state.id] == null
                      ? <dynamic>[]
                      : state.requests[state.id].entries
                          .map((e) => e.value)
                          .toList(),
                  loadState: LoadState.customMessage,
                  endMsg: '- No More Reqeust to show -',
                  builder: (BuildContext context, dynamic application) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 10,
                        vertical: 20,
                      ),
                      child: DisplayTile(
                        cardElevation: 0,
                        heroTagForPhoto: application.applicationInfo.postId,
                        photoUrl: application.applicationInfo.identity.photoUrl,
                        cardPadding: EdgeInsets.all(20),
                        onPressed: () {
                          BlocProvider.of<ViewTutorProfileBloc>(context).add(
                            InitialiseViewTutorProfile(
                                isInNestedScrollView: false,
                                profile: application,
                                isUser: application.uid ==
                                    BlocProvider.of<UserProfileBloc>(context)
                                        .state
                                        .userProfile
                                        .identity
                                        .uid),
                          );
                          Navigator.of(context)
                              .pushNamed(Routes.viewTutorProfilePage);
                        },
                        name: application.applicationInfo.name.toString(),
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
                              application.applicationInfo.details.subjects
                                  .map<String>((dynamic e) => e.toString())
                                  .toList(),
                              ColorsAndFonts.subjectBadgeColor,
                              context,
                            ),
                          ),
                          TutorProfileListUtil.wrapper(
                            TutorProfileListUtil.makeBadges(
                              application.applicationInfo.details.levels
                                  .map<String>((dynamic e) => e.toString())
                                  .toList(),
                              ColorsAndFonts.levelBadgeColor,
                              context,
                            ),
                          ),
                          TutorProfileListUtil.wrapper(
                            TutorProfileListUtil.makeBadges(
                              application
                                  .applicationInfo.requirements.classFormat
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

                // return SliverToBoxAdapter(
                //   child: Container(
                //     color: Colors.red,
                //   ),
                // );
              },
            )
          ],
        ),
      ),
    );
  }
}
