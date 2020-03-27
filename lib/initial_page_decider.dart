import 'package:cotor/features/onboarding/presentation/pages/onboard_page.dart';
import 'package:cotor/features/sign-in/app/sign_in/sign_in_page.dart';
import 'package:cotor/features/sign-in/services/auth_service.dart';
import 'package:cotor/home_page.dart';
import 'package:flutter/material.dart';

/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Note: this class used to be called [LandingPage].
class InitialPageDecider extends StatelessWidget {
  const InitialPageDecider({Key key, @required this.userSnapshot})
      : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? HomePage() : OnboardPage();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
