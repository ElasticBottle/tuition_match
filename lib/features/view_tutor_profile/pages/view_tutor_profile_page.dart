import 'package:cotor/common_widgets/bars/bottom_action_bar_new.dart';
import 'package:cotor/common_widgets/information_display/avatar.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/features/view_tutor_profile/bloc/view_tutor_profile_bloc.dart';
import 'package:cotor/features/view_tutor_profile/widgets/tutor_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewTutorProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: BlocConsumer<ViewTutorProfileBloc, ViewTutorProfileState>(
          listener: (context, state) {},
          builder: (context, state) => Container(
            color: Theme.of(context).colorScheme.primary,
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      delegate: MySliverAppBar(
                        expandedHeight: 150,
                        viewTutorProfileState: state,
                      ),
                      pinned: false,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              // color: Theme.of(context).colorScheme.onPrimary,
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                          ),
                          TutorDetails(
                            tutorProfileModel: state.profile,
                            userDetails:
                                BlocProvider.of<UserProfileBloc>(context)
                                    .state
                                    .userProfile,
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Theme.of(context).colorScheme.onPrimary,
                        height: 70,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomActionBarNew(
                    buttonText: [Strings.request],
                    buttonTextStyles: [
                      Theme.of(context)
                          .textTheme
                          .button
                          .apply(color: Colors.white)
                    ],
                    buttonOnPress: [() {}],
                    color: Theme.of(context).colorScheme.primary,
                    bgColor: Theme.of(context).colorScheme.background,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  MySliverAppBar({
    @required this.expandedHeight,
    @required this.viewTutorProfileState,
  });

  final double expandedHeight;
  final ViewTutorProfileState viewTutorProfileState;
  final double radius = 60;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        Container(
          color: Theme.of(context).colorScheme.primary,
        ),
        Positioned(
          top: 10.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: Offset(0, -shrinkOffset),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  Text(
                    'MySliverAppBar',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .apply(color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  // PopupMenuButton<String>(
                  //   onSelected: (String result) {
                  //     print(result);
                  //   },
                  //   itemBuilder: (BuildContext context) =>
                  //       <PopupMenuEntry<String>>[
                  //     const PopupMenuItem<String>(
                  //       value: 'Share',
                  //       child: Text('Working a lot harder'),
                  //     ),
                  //     const PopupMenuItem<String>(
                  //       value: 'Report Profile',
                  //       child: Text('Being a lot smarter'),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 2 - radius,
          width: radius * 2,
          height: radius * 2,
          child: Transform.translate(
            offset: Offset(0, 0.5 * -shrinkOffset),
            child: Opacity(
              opacity: 1 - shrinkOffset / expandedHeight,
              child: Card(
                shape: CircleBorder(),
                elevation: 10,
                child: Hero(
                  tag: viewTutorProfileState.profile.uid,
                  child: Avatar(
                    photoUrl: viewTutorProfileState.profile.photoUrl,
                    radius: radius,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
