import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/datasources/firestore_path.dart';
import 'package:cotor/data/models/user/user_entity.dart';
import 'package:cotor/features/authentication/data/models/authernticated_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

abstract class AuthenticationRemote {
  /// Returns a [Stream<AuthenticatedUserModel>] listening to the Auth state
  ///
  /// Triggers every time a user logs in or out
  Stream<AuthenticatedUserModel> get userStream;

  /// Used to get the currently logged in user if any
  ///
  /// Returns [AuthenticatedUserModel] for currently logged-in user.
  ///
  /// Throws [NoUserException] if there is no current user
  ///
  /// Use [getUserInfo] if you want to retrieved logged-in user info.
  Future<AuthenticatedUserModel> getCurrentUser();

//  ___ _             _   _
// / __(_)__ _ _ _   | | | |_ __
// \__ \ / _` | ' \  | |_| | '_ \
// |___/_\__, |_||_|  \___/| .__/
//       |___/             |_|

  /// Creates a user account
  ///
  /// All fields should be provided
  ///
  /// Returns [true] on successful account creation
  ///
  /// Throws [AuthenticationException] for any errors
  Future<AuthenticatedUserModel> createAccountWithEmail({
    String email,
    String password,
  });

  /// Creates a new database entry for user [uid]
  ///
  /// Throws [ServerException] for all errors
  Future<void> createNewUserDocument({
    String uid,
    String firstName,
    String lastName,
    String phoneNum,
    String countryCode,
  });

  /// Sends an email to user for verification
  ///
  /// Returns [true] if user successfully sent email verification
  ///
  /// Throws [SendEmailException] if there is no user logged in
  /// or any error while sending the verification email
  Future<bool> sendEmailVerification();

  /// Checks if currently logged in user's email is verified
  ///
  /// Returns [bool] indicating verification state of user's email
  ///
  /// Throws [AuthenticationException] if there is no user logged in
  Future<bool> isLoggedInUserEmailVerified();

  /// Sends a reset password to [email]
  ///
  /// Returns [true] if successfully sent the user's reset email
  ///
  /// Throws [AuthenticationException] if there was an error sending the email
  Future<bool> sendPasswordResetEmail(String email);

//  ___ _             ___
// / __(_)__ _ _ _   |_ _|_ _
// \__ \ / _` | ' \   | || ' \
// |___/_\__, |_||_| |___|_||_|
//       |___/

  /// Signs user in based on their email and password
  ///
  /// Throws [AuthenticationException] if there was error signing in
  Future<AuthenticatedUserModel> signInWithEmailAndPassword(
      String email, String password);

  /// Checks if user profile exists
  ///
  /// Throws [ServerException] for any error that occurs while checking

  Future<bool> isUserProfileCreated(String uid);

  /// Signs user in with their google acocunt
  ///
  /// Throws [PlatformException] on error signing in with Google
  Future<AuthenticatedUserModel> signInWithGoogle();
  // Future<User> signInWithFacebook();

  /// Signs the currently logged in user out
  ///
  /// Does nothing us no user is currently signed in
  Future<void> signOut();
}

const String USER_NOT_LOGGED_IN = 'There is no user logged in right now';

class FirebaseAuthService implements AuthenticationRemote {
  FirebaseAuthService({this.auth, this.googleSignIn, this.store, this.storage});
  final FirebaseAuth auth;
  final Firestore store;
  final FirebaseStorage storage;
  final GoogleSignIn googleSignIn;

  @override
  Stream<AuthenticatedUserModel> get userStream {
    return auth.onAuthStateChanged
        .map((event) => AuthenticatedUserModel.fromFirebaseUser(event));
  }

  @override
  Future<AuthenticatedUserModel> getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    if (user == null) {
      throw NoUserException();
    }
    try {
      user.reload();
    } catch (e) {
      throw AuthenticationException(e.code);
    }
    final FirebaseUser newUser = await auth.currentUser();
    return AuthenticatedUserModel.fromFirebaseUser(newUser);
  }

  String _getErrorMessage(String code) {
    String errorMessage = '';
    switch (code) {
      case 'ERROR_WRONG_PASSWORD':
        errorMessage = 'Wrong password.';
        break;
      case 'ERROR_USER_NOT_FOUND':
        errorMessage = 'User with this email doesn\'t exist.';
        break;
      case 'ERROR_USER_DISABLED':
        errorMessage = 'User with this email has been disabled.';
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        errorMessage = 'Too many requests. Try again later.';
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        errorMessage = 'What you are trying to do is not allowed';
        break;
      case 'ERROR_WEAK_PASSWORD':
        errorMessage = 'Password is too weak';
        break;
      case 'ERROR_INVALID_EMAIL':
        errorMessage = 'Email is invalid';
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        errorMessage = 'Email is already in use on different account';
        break;
      case 'ERROR_INVALID_CREDENTIAL':
        errorMessage = 'Your email is invalid';
        break;
      case 'ERROR_MISSING_ANDROID_PKG-NAME':
        errorMessage = 'Missing Android package name';
        break;
      case 'ERROR_MISSING_CONTINUE_URI':
        errorMessage = 'Missing continue URI';
        break;
      case 'ERROR_MISSING_IOS_BUNDLE-ID':
        errorMessage = 'Missing IOS bundle ID';
        break;
      case 'ERROR_INVALID_CONTINUE_URI':
        errorMessage = 'Invalid Continue URI';
        break;
      case 'ERROR_UNAUTHORIZED_CONTINUE_URI':
        errorMessage = 'Unauthorized URI';
        break;

      default:
        errorMessage = 'Unknown Error occurred.';
    }
    return errorMessage;
  }

//  ___ _             _   _
// / __(_)__ _ _ _   | | | |_ __
// \__ \ / _` | ' \  | |_| | '_ \
// |___/_\__, |_||_|  \___/| .__/
//       |___/             |_|

  @override
  Future<AuthenticatedUserModel> createAccountWithEmail({
    String email,
    String password,
  }) async {
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification();
      return AuthenticatedUserModel.fromFirebaseUser(result.user);
    } catch (error) {
      print(error.toString());
      throw AuthenticationException(_getErrorMessage(error.code));
    }
  }

  @override
  Future<void> createNewUserDocument({
    String uid,
    String firstName,
    String lastName,
    String phoneNum,
    String countryCode,
  }) async {
    final DocumentReference publicInfo =
        store.document(FirestorePath.users(uid));
    final DocumentReference contactInfo =
        store.document(FirestorePath.usersContactInfo(uid));
    final DocumentReference allowedContactInfo =
        store.document(FirestorePath.usersAllowedContactInfo(uid));
    final DocumentReference likedTutors =
        store.document(FirestorePath.userLikedTutors(uid));
    final DocumentReference likedAssignments =
        store.document(FirestorePath.userLikedAssignments(uid));

    final ByteData byteData = await rootBundle.load('assets/sign_in/user.png');
    final File file =
        File('${(await getTemporaryDirectory()).path}/default_user.png');
    final File toUpload = await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    String url = '';
    try {
      final StorageUploadTask uploadTask =
          storage.ref().child('images/' + uid + '.jpg').putFile(toUpload);
      final StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
      final dynamic downloadUrl = await storageSnapshot.ref.getDownloadURL();
      url = downloadUrl.toString();
    } catch (e) {
      print('user remote data source CreateNewUserDocument' + e.toString());
      throw ServerException();
    }

    final WriteBatch batch = store.batch();
    batch.setData(publicInfo,
        AuthenticatedUserModel.toNewUserDocumentMap(firstName, lastName, url));
    batch.setData(contactInfo,
        AuthenticatedUserModel.toContactInfoMap(phoneNum, countryCode));
    batch.setData(allowedContactInfo, <String, dynamic>{});
    batch.setData(likedTutors, <String, dynamic>{});
    batch.setData(likedAssignments, <String, dynamic>{});
    try {
      await batch.commit();
    } catch (e) {
      print('user remote data source CreateNewUserDocument' + e.toString());
      throw ServerException();
    }
  }

  @override
  Future<bool> sendEmailVerification() async {
    final FirebaseUser user = await auth.currentUser();
    if (user == null) {
      throw AuthenticationException(USER_NOT_LOGGED_IN);
    }
    try {
      await user.sendEmailVerification();
      return true;
    } catch (e) {
      print(e.toString());
      throw SendEmailException();
    }
  }

  @override
  Future<bool> isLoggedInUserEmailVerified() async {
    final FirebaseUser user = await auth.currentUser();
    if (user == null) {
      throw AuthenticationException(USER_NOT_LOGGED_IN);
    }
    return user.isEmailVerified;
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.toString());
      throw AuthenticationException(_getErrorMessage(e.code));
    }
  }

//  ___ _             ___
// / __(_)__ _ _ _   |_ _|_ _
// \__ \ / _` | ' \   | || ' \
// |___/_\__, |_||_| |___|_||_|
//       |___/

  @override
  Future<AuthenticatedUserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthenticatedUserModel.fromFirebaseUser(result.user);
    } catch (error) {
      print(error.toString());
      throw AuthenticationException(_getErrorMessage(error.code));
    }
  }

  @override
  Future<AuthenticatedUserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthResult authResult =
          await auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      ));
      return AuthenticatedUserModel.fromFirebaseUser(authResult.user);
    } catch (e) {
      throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token');
    }
  }

  @override
  Future<bool> isUserProfileCreated(String uid) async {
    final DocumentReference userDoc = store.document(FirestorePath.users(uid));
    final DocumentSnapshot result = await userDoc.get();
    return result.data == null;
  }
  // @override
  // Future<User> signInWithFacebook() async {
  //   final FacebookLogin facebookLogin = FacebookLogin();
  // https://github.com/roughike/flutter_facebook_login/issues/210
  //   facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   final FacebookLoginResult result =
  //       await facebookLogin.logIn(<String>['public_profile']);
  //   if (result.accessToken != null) {
  //     final AuthResult authResult = await auth.signInWithCredential(
  //       FacebookAuthProvider.getCredential(
  //           accessToken: result.accessToken.token),
  //     );
  //     return UserModel.fromFirebaseUser(authResult.user);
  //   } else {
  //     throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //   }
  // }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    // final FacebookLogin facebookLogin = FacebookLogin();
    // await facebookLogin.logOut();
    return auth.signOut();
  }
}
