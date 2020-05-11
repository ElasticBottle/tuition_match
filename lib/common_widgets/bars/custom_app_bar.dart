import 'package:cotor/common_widgets/animation/fade_on_scroll.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    this.title,
    this.controller,
  });
  final String title;
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      expandedHeight: MediaQuery.of(context).size.height / 5 * 2,
      floating: false,
      pinned: true,
      title: FadeOnScroll(
        scrollController: controller,
        fullOpacityOffset: 200,
        child: CustomAnimSwitcher(
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.headline6.apply(fontWeightDelta: 3),
            key: ValueKey<String>(title),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 8.0),
        centerTitle: true,
        background: FadeOnScroll(
          scrollController: controller,
          zeroOpacityOffset: 200,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width / 8),
                  child: CustomAnimSwitcher(
                    child: Text(
                      title.split(' ').join('\n'),
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .apply(fontWeightDelta: 3),
                      key: ValueKey<String>(title),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAnimSwitcher extends StatelessWidget {
  const CustomAnimSwitcher({this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          child: child,
          sizeFactor: animation,
        );
      },
      child: child,
    );
  }
}

// class CustomAppBar extends StatefulWidget {
//   const CustomAppBar({
//     @required this.scrollController,
//     this.titleSpacing = 150,
//     this.titleWdith = 80,
//   });
//   final ScrollController scrollController;
//   final double titleWdith;
//   final double titleSpacing;
//   @override
//   _CustomAppBarState createState() => _CustomAppBarState();
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return SliverPersistentHeader(
//       pinned: true,
//       delegate: _SliverAppBarDelegate(
//         maxHeight: MediaQuery.of(context).size.height / 5 * 2,
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () {
//             Scaffold.of(context).openDrawer();
//           },
//         ),
//         trailing: Container(
//           color: Colors.red,
//           child: IconButton(
//             icon: Icon(Icons.favorite),
//             onPressed: () {},
//           ),
//         ),
//         expandedTitle: AppBarTitle(
//           scrollController: widget.scrollController,
//           titleSpacing: widget.titleSpacing,
//           titleWidth: widget.titleWdith,
//         ),
//       ),
//     );
//   }
// }

// class AppBarTitle extends StatelessWidget {
//   const AppBarTitle({
//     this.scrollController,
//     this.titleSpacing,
//     this.titleWidth,
//   });
//   final ScrollController scrollController;
//   final double titleWidth;
//   final double titleSpacing;

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = [
//       Container(
//         width: titleWidth,
//         child: Text(
//           'Find Tutors',
//           style:
//               Theme.of(context).textTheme.headline3.apply(color: Colors.black),
//         ),
//       ),
//       SizedBox(width: titleSpacing),
//       Container(
//         width: titleWidth,
//         child: Text(
//           'page 2',
//           style:
//               Theme.of(context).textTheme.headline3.apply(color: Colors.black),
//         ),
//       ),
//       SizedBox(width: titleSpacing),
//       Container(
//         width: titleWidth,
//         child: Text(
//           'page 3',
//           style:
//               Theme.of(context).textTheme.headline3.apply(color: Colors.black),
//         ),
//       ),
//       SizedBox(width: 300),
//     ];
//     return ShaderMask(
//       shaderCallback: (Rect bounds) {
//         return LinearGradient(
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//           stops: const [0.0, 0.05, 0.1, 0.7],
//           colors: <Color>[
//             Theme.of(context).colorScheme.primary,
//             Colors.transparent,
//             Colors.transparent,
//             Theme.of(context).colorScheme.primary,
//           ],
//         ).createShader(bounds);
//       },
//       child: ListView(
//         // physics: NeverScrollableScrollPhysics(),
//         controller: scrollController,
//         scrollDirection: Axis.horizontal,
//         children: children,
//         cacheExtent: 1000,
//       ),
//       blendMode: BlendMode.srcATop,
//     );
//   }
// }

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate({
//     @required this.maxHeight,
//     @required this.leading,
//     @required this.trailing,
//     @required this.expandedTitle,
//   });

//   final double maxHeight;
//   final Widget leading;
//   final Widget trailing;
//   final Widget expandedTitle;
//   @override
//   double get minExtent => kToolbarHeight;
//   @override
//   double get maxExtent => maxHeight;
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Stack(
//       fit: StackFit.expand,
//       overflow: Overflow.clip,
//       children: [
//         Container(
//           color: Theme.of(context).colorScheme.primary,
//         ),
//         Positioned(
//           top: kToolbarHeight / 10,
//           left: 5.0,
//           child: leading,
//         ),
//         Transform.scale(
//           scale: 1 - (shrinkOffset / maxExtent) * 0.5,
//           child: Transform.translate(
//             offset: Offset(
//               MediaQuery.of(context).size.width / 20 + (0.25 * shrinkOffset),
//               -(0.6 * shrinkOffset) + MediaQuery.of(context).size.height / 5,
//             ),
//             child: expandedTitle,
//           ),
//         ),
//         Positioned(
//           top: kToolbarHeight / 10,
//           right: 5.0,
//           child: trailing,
//         ),
//       ],
//     );
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return true;
//   }
// }

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
//       overflow: Overflow.clip,
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
