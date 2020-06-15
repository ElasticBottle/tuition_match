import 'package:auto_route/auto_route_annotations.dart';
import 'package:cotor/features/Request/request_list/pages/request_list_page.dart';
import 'package:cotor/features/authentication/authentication.dart';
import 'package:cotor/features/edit_tutee_assignment/pages/edit_assignment_page.dart';
import 'package:cotor/features/edit_tutor_profile/pages/edit_tutor_page.dart';
import 'package:cotor/features/request_tutor/request_tutor_form/pages/request_tutor_form.dart';
import 'package:cotor/features/request_tutor/select_existing_assignment/pages/select_existing_assignment_page.dart';
import 'package:cotor/features/select_profile_image/select_profile_image_export.dart';
import 'package:cotor/features/view_assignment/pages/view_assignment_page.dart';
import 'package:cotor/features/view_tutor_profile/pages/view_tutor_profile_page.dart';
import 'package:cotor/initial_page_decider.dart';

@MaterialAutoRouter(generateNavigationHelperExtension: true)
class $Router {
  @initial
  InitialPageDecider initialPage;

  RegistrationPage registrationPage;
  ForgotPasswordPage forgotPasswordPage;

  ViewAssignmentPage viewAssignmentPage;
  ViewTutorProfilePage viewTutorProfilePage;

  EditTutorPage editTutorPage;
  EditAssignmentPage editAssignmentPage;

  RequestTutorForm requestTutorForm;
  SelectExistingAssignmentPage selectAssignmentPage;

  RequestListPage requestListPage;

  SelectProfileImagePage selectProfileImagePage;
}
