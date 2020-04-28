// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cotor/initial_page_decider.dart';
import 'package:cotor/features/auth_service/pages/registration_page.dart';
import 'package:cotor/features/view_assignment/pages/view_assignment_page.dart';
import 'package:cotor/features/view_tutor_profile/pages/view_tutor_profile_page.dart';
import 'package:cotor/features/edit_tutor_profile/pages/edit_tutor_page.dart';
import 'package:cotor/features/add_tutee_assignment/pages/edit_assignment_page.dart';
import 'package:cotor/features/request_tutor/request_tutor_form/pages/request_tutor_form.dart';
import 'package:cotor/features/request_tutor/select_existing_assignment/pages/select_existing_assignment_page.dart';

abstract class Routes {
  static const initialPage = '/';
  static const registrationPage = '/registration-page';
  static const viewAssignmentpage = '/view-assignmentpage';
  static const viewTutorProfilePage = '/view-tutor-profile-page';
  static const editTutorPage = '/edit-tutor-page';
  static const editAssignmentPage = '/edit-assignment-page';
  static const requestTutorForm = '/request-tutor-form';
  static const sleectAssignmentPage = '/sleect-assignment-page';
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
      case Routes.viewAssignmentpage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ViewAssignmentPage(),
          settings: settings,
        );
      case Routes.viewTutorProfilePage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => ViewTutorProfilePage(),
          settings: settings,
        );
      case Routes.editTutorPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditTutorPage(),
          settings: settings,
        );
      case Routes.editAssignmentPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditAssignmentPage(),
          settings: settings,
        );
      case Routes.requestTutorForm:
        return MaterialPageRoute<dynamic>(
          builder: (_) => RequestTutorForm(),
          settings: settings,
        );
      case Routes.sleectAssignmentPage:
        if (hasInvalidArgs<SelectExistingAssignmentPageArguments>(args)) {
          return misTypedArgsRoute<SelectExistingAssignmentPageArguments>(args);
        }
        final typedArgs = args as SelectExistingAssignmentPageArguments ??
            SelectExistingAssignmentPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => SelectExistingAssignmentPage(key: typedArgs.key),
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

//SelectExistingAssignmentPage arguments holder class
class SelectExistingAssignmentPageArguments {
  final Key key;
  SelectExistingAssignmentPageArguments({this.key});
}

//**************************************************************************
// Navigation helper methods extension
//***************************************************************************

extension RouterNavigationHelperMethods on ExtendedNavigatorState {
  Future pushInitialPage() => pushNamed(Routes.initialPage);
  Future pushRegistrationPage({
    Key key,
  }) =>
      pushNamed(Routes.registrationPage,
          arguments: RegistrationPageArguments(key: key));
  Future pushViewAssignmentpage() => pushNamed(Routes.viewAssignmentpage);
  Future pushViewTutorProfilePage() => pushNamed(Routes.viewTutorProfilePage);
  Future pushEditTutorPage() => pushNamed(Routes.editTutorPage);
  Future pushEditAssignmentPage() => pushNamed(Routes.editAssignmentPage);
  Future pushRequestTutorForm() => pushNamed(Routes.requestTutorForm);
  Future pushSleectAssignmentPage({
    Key key,
  }) =>
      pushNamed(Routes.sleectAssignmentPage,
          arguments: SelectExistingAssignmentPageArguments(key: key));
}
