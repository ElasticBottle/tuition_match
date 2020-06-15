// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cotor/initial_page_decider.dart';
import 'package:cotor/features/authentication/presentation/pages/registration/pages/registration_page.dart';
import 'package:cotor/features/authentication/presentation/pages/forgot_password/pages/forgot_password_page.dart';
import 'package:cotor/features/view_assignment/pages/view_assignment_page.dart';
import 'package:cotor/features/view_tutor_profile/pages/view_tutor_profile_page.dart';
import 'package:cotor/features/edit_tutor_profile/pages/edit_tutor_page.dart';
import 'package:cotor/features/edit_tutee_assignment/pages/edit_assignment_page.dart';
import 'package:cotor/features/request_tutor/request_tutor_form/pages/request_tutor_form.dart';
import 'package:cotor/features/request_tutor/select_existing_assignment/pages/select_existing_assignment_page.dart';
import 'package:cotor/features/Request/request_list/pages/request_list_page.dart';
import 'package:cotor/features/select_profile_image/presentation/page/select_profile_image_page.dart';

abstract class Routes {
  static const initialPage = '/';
  static const registrationPage = '/registration-page';
  static const forgotPasswordPage = '/forgot-password-page';
  static const viewAssignmentPage = '/view-assignment-page';
  static const viewTutorProfilePage = '/view-tutor-profile-page';
  static const editTutorPage = '/edit-tutor-page';
  static const editAssignmentPage = '/edit-assignment-page';
  static const requestTutorForm = '/request-tutor-form';
  static const selectAssignmentPage = '/select-assignment-page';
  static const requestListPage = '/request-list-page';
  static const selectProfileImagePage = '/select-profile-image-page';
  static const all = {
    initialPage,
    registrationPage,
    forgotPasswordPage,
    viewAssignmentPage,
    viewTutorProfilePage,
    editTutorPage,
    editAssignmentPage,
    requestTutorForm,
    selectAssignmentPage,
    requestListPage,
    selectProfileImagePage,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.initialPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => InitialPageDecider(),
          settings: settings,
        );
      case Routes.registrationPage:
        if (hasInvalidArgs<RegistrationPageArguments>(args)) {
          return misTypedArgsRoute<RegistrationPageArguments>(args);
        }
        final typedArgs =
            args as RegistrationPageArguments ?? RegistrationPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => RegistrationPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.forgotPasswordPage:
        if (hasInvalidArgs<ForgotPasswordPageArguments>(args)) {
          return misTypedArgsRoute<ForgotPasswordPageArguments>(args);
        }
        final typedArgs = args as ForgotPasswordPageArguments ??
            ForgotPasswordPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ForgotPasswordPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.viewAssignmentPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ViewAssignmentPage(),
          settings: settings,
        );
      case Routes.viewTutorProfilePage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ViewTutorProfilePage(),
          settings: settings,
        );
      case Routes.editTutorPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => EditTutorPage(),
          settings: settings,
        );
      case Routes.editAssignmentPage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => EditAssignmentPage(),
          settings: settings,
        );
      case Routes.requestTutorForm:
        return MaterialPageRoute<dynamic>(
          builder: (context) => RequestTutorForm(),
          settings: settings,
        );
      case Routes.selectAssignmentPage:
        if (hasInvalidArgs<SelectExistingAssignmentPageArguments>(args)) {
          return misTypedArgsRoute<SelectExistingAssignmentPageArguments>(args);
        }
        final typedArgs = args as SelectExistingAssignmentPageArguments ??
            SelectExistingAssignmentPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              SelectExistingAssignmentPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.requestListPage:
        if (hasInvalidArgs<RequestListPageArguments>(args)) {
          return misTypedArgsRoute<RequestListPageArguments>(args);
        }
        final typedArgs =
            args as RequestListPageArguments ?? RequestListPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => RequestListPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.selectProfileImagePage:
        return MaterialPageRoute<dynamic>(
          builder: (context) => SelectProfileImagePage(),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//RegistrationPage arguments holder class
class RegistrationPageArguments {
  final Key key;
  RegistrationPageArguments({this.key});
}

//ForgotPasswordPage arguments holder class
class ForgotPasswordPageArguments {
  final Key key;
  ForgotPasswordPageArguments({this.key});
}

//SelectExistingAssignmentPage arguments holder class
class SelectExistingAssignmentPageArguments {
  final Key key;
  SelectExistingAssignmentPageArguments({this.key});
}

//RequestListPage arguments holder class
class RequestListPageArguments {
  final Key key;
  RequestListPageArguments({this.key});
}

// *************************************************************************
// Navigation helper methods extension
// **************************************************************************

extension RouterNavigationHelperMethods on ExtendedNavigatorState {
  Future pushInitialPage() => pushNamed(Routes.initialPage);

  Future pushRegistrationPage({
    Key key,
  }) =>
      pushNamed(
        Routes.registrationPage,
        arguments: RegistrationPageArguments(key: key),
      );

  Future pushForgotPasswordPage({
    Key key,
  }) =>
      pushNamed(
        Routes.forgotPasswordPage,
        arguments: ForgotPasswordPageArguments(key: key),
      );

  Future pushViewAssignmentPage() => pushNamed(Routes.viewAssignmentPage);

  Future pushViewTutorProfilePage() => pushNamed(Routes.viewTutorProfilePage);

  Future pushEditTutorPage() => pushNamed(Routes.editTutorPage);

  Future pushEditAssignmentPage() => pushNamed(Routes.editAssignmentPage);

  Future pushRequestTutorForm() => pushNamed(Routes.requestTutorForm);

  Future pushSelectAssignmentPage({
    Key key,
  }) =>
      pushNamed(
        Routes.selectAssignmentPage,
        arguments: SelectExistingAssignmentPageArguments(key: key),
      );

  Future pushRequestListPage({
    Key key,
  }) =>
      pushNamed(
        Routes.requestListPage,
        arguments: RequestListPageArguments(key: key),
      );

  Future pushSelectProfileImagePage() =>
      pushNamed(Routes.selectProfileImagePage);
}
