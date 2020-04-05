class Strings {
  // Generic strings
  static const String ok = 'OK';
  static const String cancel = 'Cancel';

  // Logout
  static const String logout = 'Logout';
  static const String logoutAreYouSure =
      'Are you sure that you want to logout?';
  static const String logoutFailed = 'Logout failed';

  // Sign In Page
  static const String signIn = 'Sign in';
  static const String signInWithEmailPassword =
      'Sign in with email and password';
  static const String signInWithEmailLink = 'Sign in with email link';
  static const String signInWithFacebook = 'Sign in with Facebook';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String goAnonymous = 'Go anonymous';
  static const String or = 'or';

  // Email & Password page
  static const String register = 'Register';
  static const String forgotPassword = 'Forgot password';
  static const String forgotPasswordQuestion = 'Forgot password?';
  static const String createAnAccount = 'Create an account';
  static const String needAnAccount = 'Need an account? Register';
  static const String haveAnAccount = 'Have an account? Sign in';
  static const String signInFailed = 'Sign in failed';
  static const String registrationFailed = 'Registration failed';
  static const String passwordResetFailed = 'Password reset failed';
  static const String sendResetLink = 'Send Reset Link';
  static const String backToSignIn = 'Back to sign in';
  static const String resetLinkSentTitle = 'Reset link sent';
  static const String resetLinkSentMessage =
      'Check your email to reset your password';
  static const String emailLabel = 'Email';
  static const String emailHint = 'test@test.com';
  static const String password8CharactersLabel = 'Password (8+ characters)';
  static const String passwordLabel = 'Password';
  static const String invalidEmailErrorText = 'Email is invalid';
  static const String invalidEmailEmpty = 'Email can\'t be empty';
  static const String invalidPasswordTooShort = 'Password is too short';
  static const String invalidPasswordEmpty = 'Password can\'t be empty';

  // Email link page
  static const String submitEmailAddressLink =
      'Submit your email address to receive an activation link.';
  static const String checkYourEmail = 'Check your email';

  static String activationLinkSent(String email) =>
      'We have sent an activation link to $email';
  static const String errorSendingEmail = 'Error sending email';
  static const String sendActivationLink = 'Send activation link';
  static const String activationLinkError = 'Email activation error';
  static const String submitEmailAgain =
      'Please submit your email address again to receive a new activation link.';
  static const String userAlreadySignedIn =
      'Received an activation link but you are already signed in.';
  static const String isNotSignInWithEmailLinkMessage =
      'Invalid activation link';

  // Home page
  static const String homePage = 'Home Page';

  // Developer menu
  static const String developerMenu = 'Developer menu';
  static const String authenticationType = 'Authentication type';
  static const String firebase = 'Firebase';
  static const String mock = 'Mock';

  // AssignmentList page
  static const String assignmentTitle = 'Assignments';
  static const String cachedAssignmentLoadedMsg = 'Last retrieved copy loaded';

  // AddAssignment page
  static const String addAssignment = 'Add Assignment';
  static const String subject = 'Subject';
  static const String level = 'Level';
  // AddAssignment page level drodown
  static const String levelDropDownHint = 'Choose a level';
  static const String levelDropDownLabel = 'Level';

  // EndTile
  static const String endTileAllItemLoaded = '- All items have been loaded -';

  // AddTuteeAssignment Page CustomFTextField
  static const String location = 'Location';
  static const String locationHelperText =
      'Postal code, Block/Unit, Num to make it easy for Tutors!';
  static const String timing = 'Timing';
  static const String timingHelperText = 'When do you want lessons at?';
  static const String freq = 'Frequency';
  static const String freqHelperText = 'How often do you want lessons?';
  static const String rate = 'Rate';
  static const String minRate = 'Min';
  static const String maxRate = 'Max';
  static const String additionalRemarks = 'Additional Remarks';
  static const String additionalRemarksHelperText =
      'Anything else? Special condition, emphasis points etc.';

  static const String rateMax = 'Max';
  static const String rateMin = 'Min';

  static const String addTuteeCheckBoxError =
      'Please select at least one option';
  static const String addTuteeTextFieldError = 'Field cannot be empty';
}
