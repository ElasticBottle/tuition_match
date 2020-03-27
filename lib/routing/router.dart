import 'package:auto_route/auto_route_annotations.dart';
import 'package:cotor/features/sign-in/app/email_link_error_presenter.dart';
import 'package:cotor/features/sign-in/app/sign_in/sign_in_page.dart';

@MaterialAutoRouter(generateNavigationHelperExtension: true)
class $Router {
  @initial
  EmailLinkErrorPresenter emailLinkErrorPresenter;

  SignInPageBuilder signInPageBuilder;
}
