// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cotor/initial_page_decider.dart';
import 'package:cotor/features/view_assignment/pages/view_assignment_page.dart';
import 'package:cotor/features/auth_service/pages/registration_page.dart';

abstract class Routes {
  static const initialPage = '/';
  static const viewAssignmentpage = '/view-assignmentpage';
  static const registrationPage = '/registration-page';
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
      case Routes.initialPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => InitialPageDecider(),
          settings: settings,
        );
      case Routes.viewAssignmentpage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ViewAssignmentPage(),
          settings: settings,
        );
      case Routes.registrationPage:
        if (hasInvalidArgs<RegistrationPageArguments>(args)) {
          return misTypedArgsRoute<RegistrationPageArguments>(args);
        }
        final typedArgs =
            args as RegistrationPageArguments ?? RegistrationPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => RegistrationPage(key: typedArgs.key),
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

//RegistrationPage arguments holder class
class RegistrationPageArguments {
  final Key key;
  RegistrationPageArguments({this.key});
}

//**************************************************************************
// Navigation helper methods extension
//***************************************************************************

extension RouterNavigationHelperMethods on ExtendedNavigatorState {
  Future pushInitialPage() => pushNamed(Routes.initialPage);
  Future pushViewAssignmentpage() => pushNamed(Routes.viewAssignmentpage);
  Future pushRegistrationPage({
    Key key,
  }) =>
      pushNamed(Routes.registrationPage,
          arguments: RegistrationPageArguments(key: key));
}
