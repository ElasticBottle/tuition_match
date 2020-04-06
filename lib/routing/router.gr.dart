// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cotor/features/sign-in/app/email_link_error_presenter.dart';
import 'package:cotor/features/sign-in/app/sign_in/sign_in_page.dart';
import 'package:cotor/features/view_assignment/pages/view_assignment_page.dart';

abstract class Routes {
  static const emailLinkErrorPresenter = '/';
  static const signInPageBuilder = '/sign-in-page-builder';
  static const viewAssignmentpage = '/view-assignmentpage';
}

class Router extends RouterBase {
  //This will probably be removed in future versions
  //you should call ExtendedNavigator.ofRouter<Router>() directly
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.emailLinkErrorPresenter:
        if (hasInvalidArgs<EmailLinkErrorPresenterArguments>(args)) {
          return misTypedArgsRoute<EmailLinkErrorPresenterArguments>(args);
        }
        final typedArgs = args as EmailLinkErrorPresenterArguments ??
            EmailLinkErrorPresenterArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailLinkErrorPresenter(
              key: typedArgs.key,
              context: typedArgs.context,
              child: typedArgs.child),
          settings: settings,
        );
      case Routes.signInPageBuilder:
        return MaterialPageRoute<dynamic>(
          builder: (_) => SignInPageBuilder(),
          settings: settings,
        );
      case Routes.viewAssignmentpage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ViewAssignmentPage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//EmailLinkErrorPresenter arguments holder class
class EmailLinkErrorPresenterArguments {
  final Key key;
  final BuildContext context;
  final Widget child;
  EmailLinkErrorPresenterArguments({this.key, this.context, this.child});
}

//**************************************************************************
// Navigation helper methods extension
//***************************************************************************

extension RouterNavigationHelperMethods on ExtendedNavigatorState {
  Future pushEmailLinkErrorPresenter({
    Key key,
    BuildContext context,
    Widget child,
  }) =>
      pushNamed(Routes.emailLinkErrorPresenter,
          arguments: EmailLinkErrorPresenterArguments(
              key: key, context: context, child: child));
  Future pushSignInPageBuilder() => pushNamed(Routes.signInPageBuilder);
  Future pushViewAssignmentpage() => pushNamed(Routes.viewAssignmentpage);
}
