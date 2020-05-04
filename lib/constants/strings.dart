class Strings {
  // Generic strings
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String dismiss = 'Dismiss';

  // ___
  //| __|_ _ _ _ ___ _ _ ___
  //| _|| '_| '_/ _ \ '_(_-<
  //|___|_| |_| \___/_| /__/

  /// Used when displaying side effects to inform Users of what went wrong.
  ///
  /// Naming Convention:
  /// - Starts with the desc of error
  /// - ends with 'ErrorMsg'

  // Error messages
  static const String noUserFailureErrorMsg =
      'There is currently no user to create profile for.';
  static const String serverFailureErrorMsg =
      'Sorry, Our Server is having problems processing the request (||^_^), retrieving last fetched list';
  static const String networkFailureErrorMsg =
      'No internet access, please check your connection, retrieving last fetched list';
  static const String cacheFailureErrorMsg =
      'No last fetched list, please try again when you\'re online!';
  static const String cannotSaveNameAndPhoneNumber =
      'An error occured trying to process the application';
  static const String unknownFailureErrorMsg =
      'Something went wrong and we don\'t know why, drop us a message at jeffhols18@gami.com and we\'ll get you sorted right away.';

  //            _   _         _         __  __
  //  __ _ _  _| |_| |_    __| |_ _  _ / _|/ _|
  // / _` | || |  _| ' \  (_-<  _| || |  _|  _|
  // \__,_|\_,_|\__|_||_| /__/\__|\_,_|_| |_|
  // Logout
  static const String logout = 'Logout';
  static const String logoutAreYouSure =
      'Are you sure that you want to logout?';
  static const String logoutFailed = 'Logout failed';

  //  __                                 _   _   _        _                    _                __ _     _    _
  // / _|___ _ _ _ __  ___  __ _ _ _  __| | | |_| |_  ___(_)_ _  __ ____ _ _ _(_)___ _  _ ___  / _(_)___| |__| |___
  //|  _/ _ \ '_| '  \(_-< / _` | ' \/ _` | |  _| ' \/ -_) | '_| \ V / _` | '_| / _ \ || (_-< |  _| / -_) / _` (_-<
  //|_| \___/_| |_|_|_/__/ \__,_|_||_\__,_|  \__|_||_\___|_|_|    \_/\__,_|_| |_\___/\_,_/__/ |_| |_\___|_\__,_/__/

  /// Used for the labelling, hinting, informing, and describing of text fields
  /// Naming Convention:
  /// ERROR = Prefaced with 'error'
  /// LABELS = Ends with 'Label'
  /// HINTS = Ends with 'Hint'
  /// ADDITIONAL INFO ABOVE = Ends with 'Info'
  /// ADDITIONAL INFO BELOW = Ends with 'Desc'
  /// BUTTON TEXT = Ends with 'ButtonText'

  //Generic form errors
  static const String errorFieldEmpty = 'Field cannot be empty';
  static const String errorCheckBoxEmpty = 'Please select at least one option';
  static const String errorRateInvalid = 'Pleaes enter a proper number';
  static const String errorPhoneNumInvalid =
      'Please enter a real phone number so you can connect with students/tutors!';

  // Auth form common fields
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String phoneNumLabel = 'Phone Number';
  static const String phoneNumHint = '+65 87654321';

  // Login page form
  static const String signInButtonText = 'Sign In';
  static const String forgotPasswordButtonText = 'Forgot password';
  static const String signInWithGoogleButtonText = 'Sign in with Google';
  static const String createAnAccountButtonText = 'Create an account';
  static const String errorEmailEmpty = 'Email can\'t be empty';
  static const String errorPasswordEmpty = 'Password can\'t be empty';

  // registration page
  static const String emailHint = 'test@test.com';
  static const String errorEmailInvalid = 'Email is invalid';
  static const String passwordHint = 'Password (8+ characters)';
  static const String errorPasswordTooShort = 'Password is too short';
  static const String firstNameLabel = 'First Name';
  static const String lastNameLabel = 'Last Name';
  static const String registerButtonText = 'Register';

  // First time google sign in page
  static const String saveDetailsButtonText = 'Save Details';
  static const String phoneNumDesc =
      'Only provided with your consent to make arrangements';

  // Tutor and Tutee commons Fields
  static const String levelLabel = 'Level';
  static const String levelHint = 'Choose a level';
  static const String subjectLabel = 'Subject';
  static const String classFormatLabel = 'Class Format(s)';
  static const String rateLabel = 'Rate';
  static const String rateMaxLabel = 'Max';
  static const String rateMinLabel = 'Min';
  static const String locationLabel = 'Location';
  static const String locationHint = 'Postal code, Block/Unit.';
  static const String timing = 'Timing';
  static const String timingHint = 'When do you want lessons at?';

  // Edit TuteeAssignment Page
  static const String editAssignment = 'Edit Assignment';
  static const String freqLabel = 'Frequency';
  static const String freqHintLabel = 'How often do you want lessons?';
  static const String additionalRemarksLabel = 'Additional Remarks';
  static const String additionalRemarksHint =
      'Anything else? Special condition, emphasis points etc.';
  static const String addAssignmentButtonText = 'Add Assignment';
  static const String updateAssignmentButtonText = 'Update Assignment';

  // Edit TutorProfilePage
  static const String editTutorProfile = 'Edit Profile';
  static const String levelsTaughtLabel = 'Levels Taught';
  static const String subjectsTaughtLabel = 'Subjects Taught';
  static const String qualificationsLabel = 'Qualifications';
  static const String sellingPointsLabel = 'Description';

  // TutorRequestForm
  static const String proposedRateLabel = 'Proposed Rate';
  static const String tutorRateInfo = 'Tutor rates';
  static const String tutorTimingsInfo = 'Tutor\' Preferred Timings';
  static const String tutorPreferredLocationInfo =
      'Tutor\'s Preferred Location';
  static const String requestTutorButtonText = 'Request Tutor';

  //.____    .__          __    __________
  //|    |   |__| _______/  |_  \______   \_____     ____   ____   ______
  //|    |   |  |/  ___/\   __\  |     ___/\__  \   / ___\_/ __ \ /  ___/
  //|    |___|  |\___ \  |  |    |    |     / __ \_/ /_/  >  ___/ \___ \
  //|_______ \__/____  > |__|    |____|    (____  /\___  / \___  >____  >
  //        \/       \/                         \//_____/      \/     \/

  // AssignmentList page
  static const String assignmentTitle = 'Assignments';
  static const String cachedAssignmentLoadedMsg = 'Last retrieved copy loaded';

  // TutorListPage
  static const String getNextListError =
      'Error retriving next list, please wait and try again later.';

  // EndTile
  static const String allItemLoaded = '- All items have been loaded -';

  // View Assignment Page
  static const String assignment = 'Assignment';

  // View TutorProfile Page
  static const String tutorProfileTitle = 'Tutor Profiles';
  static const String cachedProfileLoadedMsg = 'Last Retrieved Copy Loaded';

  // UserProfilePage
  static const String yourProfile = 'Your Profile';
  static const String startTeachingNow = 'Start Teaching Now';
  static const String myAssignment = 'My Assignments';
  static const String bio = 'Bio';

  // Select Existing Assignment Page
  static const String selectExistingAssignment = 'Select Previous Assignment';

  // BottomActionBar
  static const String outgoingApplications = 'Applications';
  static const String incomingRequests = 'Requests';
  static const String incomingApplications = 'Applications';
  static const String outgoingRequests = 'Requests';
  static const String applied = 'Applied';
  static const String apply = 'Apply';
  static const String request = 'Reqeust';
  static const String requested = 'Reqeusted';
  static const String accept = 'Accept';
  static const String deny = 'Deny';
}
