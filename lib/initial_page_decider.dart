import 'package:cotor/features/auth_service/bloc/auth_service_bloc/auth_service_bloc.dart';
import 'package:cotor/features/auth_service/pages/first_time_google_sign_in_page.dart';
import 'package:cotor/features/auth_service/pages/login_page.dart';
import 'package:cotor/features/auth_service/verify_email/pages/verify_email_page.dart';
import 'package:cotor/features/onboarding/presentation/pages/onboard_page.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/home_page.dart';
import 'package:cotor/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Note: this class used to be called [LandingPage].
class InitialPageDecider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthServiceBloc, AuthServiceState>(
      builder: (context, state) {
        if (state is Uninitialized) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is FirstTimeAppLaunch) {
          return OnboardPage();
        } else if (state is Authenticated) {
          return BlocProvider(
            create: (context) => sl<UserProfileBloc>()..add(UserEnterHompage()),
            child: HomePage(),
          );
        } else if (state is NewGoogleUser) {
          return FirstTimeGoogleSignInPage();
        } else if (state is UnverifiedEmail) {
          return VerifyEmailPage();
        } else if (state is Unauthenticated) {
          return LoginPage();
        }
        return Container(
          child: Center(
            child: Text('error occured'),
          ),
        );
      },
    );
  }
}
