import 'package:auto_route/auto_route_annotations.dart';
import 'package:cotor/features/view_assignment/pages/view_assignment_page.dart';
import 'package:cotor/features/auth_service/pages/registration_page.dart';
import 'package:cotor/initial_page_decider.dart';

@MaterialAutoRouter(generateNavigationHelperExtension: true)
class $Router {
  @initial
  InitialPageDecider initialPage;

  ViewAssignmentPage viewAssignmentpage;
  RegistrationPage registrationPage;
}
