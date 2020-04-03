// import 'dart:async';

// import 'package:cotor/common_widgets/avatar.dart';
// import 'package:cotor/common_widgets/platform_alert_dialog.dart';
// import 'package:cotor/common_widgets/platform_exception_alert_dialog.dart';
// import 'package:cotor/constants/keys.dart';
// import 'package:cotor/constants/strings.dart';
// import 'package:cotor/features/sign-in/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/services.dart';

// class HomePage extends StatelessWidget {
//   Future<void> _signOut(BuildContext context) async {
//     try {
//       final AuthService auth = Provider.of<AuthService>(context, listen: false);
//       await auth.signOut();
//     } on PlatformException catch (e) {
//       await PlatformExceptionAlertDialog(
//         title: Strings.logoutFailed,
//         exception: e,
//       ).show(context);
//     }
//   }

//   Future<void> _confirmSignOut(BuildContext context) async {
//     final bool didRequestSignOut = await PlatformAlertDialog(
//       title: Strings.logout,
//       content: Strings.logoutAreYouSure,
//       cancelActionText: Strings.cancel,
//       defaultActionText: Strings.logout,
//     ).show(context);
//     if (didRequestSignOut == true) {
//       _signOut(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(Strings.homePage),
//         actions: <Widget>[
//           FlatButton(
//             key: Key(Keys.logout),
//             child: Text(
//               Strings.logout,
//               style: TextStyle(
//                 fontSize: 18.0,
//                 color: Colors.white,
//               ),
//             ),
//             onPressed: () => _confirmSignOut(context),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(130.0),
//           child: _buildUserInfo(user),
//         ),
//       ),
//     );
//   }

//   Widget _buildUserInfo(User user) {
//     return Column(
//       children: [
//         Avatar(
//           photoUrl: user.photoUrl,
//           radius: 50,
//           borderColor: Colors.black54,
//           borderWidth: 2.0,
//         ),
//         SizedBox(height: 8),
//         if (user.displayName != null)
//           Text(
//             user.displayName,
//             style: TextStyle(color: Colors.white),
//           ),
//         SizedBox(height: 8),
//       ],
//     );
//   }
// }

import 'package:cotor/constants/spacings_and_heights.dart';
import 'package:cotor/features/tutee_assignment_list/pages/assignment_list_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey =
      GlobalKey<CurvedNavigationBarState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _currentPage,
        height: SpacingsAndHeights.bottomBarHeight,
        items: <Widget>[
          Icon(Icons.list, size: SpacingsAndHeights.bottomBarIconSize),
          Icon(Icons.library_books, size: SpacingsAndHeights.bottomBarIconSize),
          Icon(Icons.notifications, size: SpacingsAndHeights.bottomBarIconSize),
          Icon(Icons.perm_identity, size: SpacingsAndHeights.bottomBarIconSize),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeOutQuint,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          _pageController.animateToPage(
            index,
            curve: Curves.decelerate,
            duration: Duration(
              milliseconds: 200,
            ),
          );
          _currentPage = index;
        },
      ),
      body: PageView(
        controller: _pageController,
        children: [
          AssignmentListPage(),
          TutorListPage(),
          NotificationPage(),
          ProfilePage(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}

class TutorListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Text('Tutor list page'),
      ),
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

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text('Profile page'),
      ),
    );
  }
}
