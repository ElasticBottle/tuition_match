import 'package:cotor/common_widgets/bars/app_drawer.dart';
import 'package:cotor/common_widgets/bars/custom_app_bar.dart';
import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/features/edit_tutee_assignment/bloc/edit_tutee_assignment_bloc.dart';
import 'package:cotor/features/edit_tutee_assignment/pages/edit_assignment_page.dart';
import 'package:cotor/features/onboarding/data/models/onboard_info_model.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/tutee_assignments_bloc.dart';
import 'package:cotor/features/tutee_assignment_list/pages/assignment_list_page.dart';
import 'package:cotor/features/user_profile/bloc/user_profile_page_bloc.dart';
import 'package:cotor/features/user_profile/pages/user_profile_page.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/features/tutor_profile_list/bloc/tutor_profile_list_bloc.dart';
import 'package:cotor/features/tutor_profile_list/pages/tutor_profile_list_page.dart';
import 'package:cotor/injection_container.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey =
      GlobalKey<CurvedNavigationBarState>();
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  // final double _titleSpacing = 80;
  // final double _titleWidth = 170;
  // final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _titles = [
    'Find Tutors',
    'My Assignments',
    'My Profile',
  ];

  String _title;

  UserProfileBloc userProfileBloc;
  @override
  void initState() {
    // userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    // _pageController.addListener(_titleBarListener);

    _title = _titles[0];
    super.initState();
  }

  // void _titleBarListener() {

  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _currentPage,
          height: SpacingsAndHeights.bottomBarHeight,
          items: <Widget>[
            Icon(Icons.list, size: SpacingsAndHeights.bottomBarIconSize),
            // Icon(Icons.library_books, size: SpacingsAndHeights.bottomBarIconSize),
            // Icon(Icons.add, size: SpacingsAndHeights.bottomBarIconSize),
            Icon(Icons.book, size: SpacingsAndHeights.bottomBarIconSize),
            Icon(Icons.perm_identity,
                size: SpacingsAndHeights.bottomBarIconSize),
          ],
          color: Theme.of(context).colorScheme.surface,
          buttonBackgroundColor: Theme.of(context).colorScheme.surface,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.fastLinearToSlowEaseIn,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            _pageController.animateToPage(
              index,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(
                milliseconds: 300,
              ),
            );
            _currentPage = index;
          },
        ),
        // drawer: AppDrawer(),
        body: NestedScrollView(
          controller: _scrollController,
          // controller: _scrollViewController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: CustomAppBar(
                  title: _title,
                  controller: _scrollController,
                ),
              ),
            ];
          },
          body: PageView(
            controller: _pageController,
            children: [
              // BlocProvider<AssignmentsBloc>(
              //   create: (BuildContext context) =>
              //       sl<AssignmentsBloc>()..add(GetAssignmentList()),
              // child: AssignmentListPage(),
              // ),
              // BlocProvider<TutorProfileListBloc>(
              //   create: (context) =>
              //       sl<TutorProfileListBloc>()..add(GetTutorProfileList()),
              //   child: TutorProfileListPage(),
              // ),
              // BlocProvider<EditTuteeAssignmentBloc>(
              //   create: (BuildContext context) => sl<EditTuteeAssignmentBloc>(),
              //   child: EditAssignmentPage(),
              // ),
              TutorListPage(),
              TutorListPage(),
              NotificationPage(),
              // BlocProvider<UserProfilePageBloc>(
              //   create: (BuildContext context) => sl<UserProfilePageBloc>(),
              //   child: UserProfilePage(),
              // ),
              // BlocProvider(
              //   create: (context) => sl<EditTutorProfileBloc>()
              //     ..add(
              //       InitialiseProfileFields(
              //         userDetails: BlocProvider.of<UserProfileBloc>(context)
              //             .state
              //             .userProfile,
              //         tutorProfile: TutorProfileModel(),
              //       ),
              //     ),
              //   child: EditTutorPage(),
              // )
              // ProfilePage(),
            ],
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
                _title = _titles[index];
              });
            },
          ),
        ),
      ),
    );
  }
}

class TutorListPage extends StatelessWidget {
  const TutorListPage();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // The "controller" and "primary" members should be left
      // unset, so that the NestedScrollView can control this
      // inner scroll view.
      // If the "controller" property is set, then this scroll
      // view will not be associated with the NestedScrollView.
      // The PageStorageKey should be unique to this ScrollView;
      // it allows the list to remember its scroll position when
      // the tab view is not on the screen.
      key: PageStorageKey<String>('name'),
      slivers: <Widget>[
        SliverOverlapInjector(
          // This is the flip side of the SliverOverlapAbsorber above.
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          // In this example, the inner scroll view has
          // fixed-height list items, hence the use of
          // SliverFixedExtentList. However, one could use any
          // sliver widget here, e.g. SliverList or SliverGrid.
          sliver: SliverFixedExtentList(
            // The items in this example are fixed to 48 pixels
            // high. This matches the Material Design spec for
            // ListTile widgets.
            itemExtent: 48.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // This builder is called for each child.
                // In this example, we just number each list item.
                return ListTile(
                  title: Text('Item $index'),
                );
              },
              // The childCount of the SliverChildBuilderDelegate
              // specifies how many children this inner list
              // has. In this example, each tab has a list of
              // exactly 30 items, but this is arbitrary.
              childCount: 30,
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text('notificaiton page'),
      ),
    );
  }
}
