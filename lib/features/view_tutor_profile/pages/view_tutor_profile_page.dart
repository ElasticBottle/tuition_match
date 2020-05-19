import 'package:cotor/common_widgets/bars/bottom_bar_decider.dart';
import 'package:cotor/common_widgets/bars/custom_app_bar.dart';
import 'package:cotor/common_widgets/information_display/profile_picture_display.dart';
import 'package:cotor/constants/keys.dart';
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
        color: Theme.of(context).colorScheme.surface,
        child: BlocConsumer<ViewTutorProfileBloc, ViewTutorProfileState>(
          listener: (context, state) {},
          builder: (context, state) => Stack(
            children: [
              CustomScrollView(
                key: state.isInNestedScrollView
                    ? PageStorageKey<String>(Keys.viewTutorPageKey)
                    : null,
                slivers: [
                  if (state.isInNestedScrollView)
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                  if (!state.isInNestedScrollView) CustomAppBar(),
                  // SliverPersistentHeader(
                  //   delegate: MySliverAppBar(
                  //     expandedHeight: 150,
                  //     viewTutorProfileState: state,
                  //   ),
                  //   pinned: false,
                  // ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        ProfilePictureDisplay(
                          heroTag: state.isInNestedScrollView
                              ? ''
                              : state.profile.identity?.uid,
                          showAddProfilePicButton: state.isUser,
                          photoUrl: state.isUser
                              ? BlocProvider.of<UserProfileBloc>(context)
                                  .state
                                  .userProfile
                                  .identity
                                  ?.photoUrl
                              : state.profile.identity?.photoUrl,
                        ),
                        SizedBox(height: 10),
                        TutorDetails(
                          tutorProfile: state.profile,
                          isUserProfile: state.isUser,
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BottomBarDecider(
                      post: state.profile,
                    ),
                  ),
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: BottomActionBarNew(
              //     buttonProperties: [
              //       ButtonProperties(
              //         text: Strings.request,
              //         style: Theme.of(context)
              //             .textTheme
              //             .button
              //             .apply(color: Colors.white),
              //         color: Theme.of(context).colorScheme.error,
              //         onPressed: () {
              // final User user =
              //     BlocProvider.of<UserProfileBloc>(context)
              //         .state
              //         .userProfile;

              // if (user.userAssignments.isEmpty) {
              //   BlocProvider.of<RequestTutorFormBloc>(context).add(
              //     InitialiseRequestProfileFields(
              //       requestingProfile: state.profile,
              //       userRefAssignment: TuteeAssignment(),
              //       userDetails: user,
              //     ),
              //   );
              //   Navigator.of(context)
              //       .pushNamed(Routes.requestTutorForm);
              // } else {
              //   BlocProvider.of<SelectExistingAssignmentBloc>(
              //           context)
              //       .add(
              //     InitialiseAssignmentsToSelect(
              //       requestingProfile: state.profile,
              //       userDetails: user,
              //     ),
              //   );
              //   Navigator.of(context)
              //       .pushNamed(Routes.sleectAssignmentPage);
              // }
              //     },
              //   ),
              // ],
              // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// class MySliverAppBar extends SliverPersistentHeaderDelegate {
//   MySliverAppBar({
//     @required this.expandedHeight,
//     @required this.viewTutorProfileState,
//   });

//   final double expandedHeight;
//   final ViewTutorProfileState viewTutorProfileState;
//   final double radius = 60;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Stack(
//       fit: StackFit.expand,
//       overflow: Overflow.visible,
//       children: [
//         Container(
//           color: Theme.of(context).colorScheme.primary,
//         ),
//         Positioned(
//           top: 10.0,
//           child: Align(
//             alignment: Alignment.topCenter,
//             child: Transform.translate(
//               offset: Offset(0, -shrinkOffset),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.arrow_back),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     color: Theme.of(context).colorScheme.onPrimary,
//                   ),
//                   Text(
//                     'MySliverAppBar',
//                     style: Theme.of(context)
//                         .textTheme
//                         .headline6
//                         .apply(color: Theme.of(context).colorScheme.onPrimary),
//                   ),
//                   // PopupMenuButton<String>(
//                   //   onSelected: (String result) {
//                   //     print(result);
//                   //   },
//                   //   itemBuilder: (BuildContext context) =>
//                   //       <PopupMenuEntry<String>>[
//                   //     const PopupMenuItem<String>(
//                   //       value: 'Share',
//                   //       child: Text('Working a lot harder'),
//                   //     ),
//                   //     const PopupMenuItem<String>(
//                   //       value: 'Report Profile',
//                   //       child: Text('Being a lot smarter'),
//                   //     ),
//                   //   ],
//                   // )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: expandedHeight / 2 - shrinkOffset,
//           left: MediaQuery.of(context).size.width / 2 - radius,
//           width: radius * 2,
//           height: radius * 2,
//           child: Transform.translate(
//             offset: Offset(0, 0.5 * -shrinkOffset),
//             child: Opacity(
//               opacity: 1 - shrinkOffset / expandedHeight,
//               child: Card(
//                 shape: CircleBorder(),
//                 elevation: 10,
//                 child: Hero(
//                   tag: viewTutorProfileState.profile.identity.uid,
//                   child: Avatar(
//                     photoUrl: viewTutorProfileState.profile.identity.photoUrl,
//                     radius: radius,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   double get maxExtent => expandedHeight;

//   @override
//   double get minExtent => kToolbarHeight;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
// }
