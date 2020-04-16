import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/datasources/firestore_path.dart';
import 'package:cotor/data/models/user_model.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthServiceRemote {
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<bool> createAccountWithEmail({
    String email,
    String password,
  });
  Future<bool> isUsernameValid(String username);
  Future<void> sendEmailVerification();
  Future<bool> isLoggedInUserEmailVerified();
  Future<void> sendPasswordResetEmail(String email);
  Future<User> signInWithGoogle();
  // Future<User> signInWithFacebook();
  Future<void> signOut();
}

const String USER_NOT_LOGGED_IN = 'There is no user logged in right now';

class FirebaseAuthService implements AuthServiceRemote {
  FirebaseAuthService({this.auth, this.googleSignIn, this.store});
  final FirebaseAuth auth;
  final Firestore store;
  final GoogleSignIn googleSignIn;

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

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    String errorMessage = '';
    UserModel user;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = UserModel.fromFirebaseUser(result.user);
      // user = result.user;
      // name = user.displayName;
      // email = user.email;
      // userId = user.uid;
    } catch (error) {
      print(error.toString());
      errorMessage = _getErrorMessage(error.code);
    }
    if (errorMessage != null) {
      throw AuthenticationException(errorMessage);
    }

    return user;
  }

  @override
  Future<bool> createAccountWithEmail({
    String email,
    String password,
    String username,
  }) async {
    String errorMessage = '';
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await sendEmailVerification();
    } catch (error) {
      print(error.toString());
      errorMessage = _getErrorMessage(error.code);
    }
    if (errorMessage != '') {
      throw AuthenticationException(errorMessage);
    }
    return true;
  }

  @override
  Future<void> sendEmailVerification() async {
    final FirebaseUser user = await auth.currentUser();
    String errorMessage = '';
    if (user == null) {
      throw AuthenticationException(USER_NOT_LOGGED_IN);
    }
    try {
      return await user.sendEmailVerification();
    } catch (e) {
      print(e.toString());
      errorMessage = _getErrorMessage(e.code);
    }
    if (errorMessage.isNotEmpty) {
      throw AuthenticationException(errorMessage);
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
  Future<void> sendPasswordResetEmail(String email) async {
    String errorMessage = '';
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      errorMessage = _getErrorMessage(e.code);
    }
    if (errorMessage.isNotEmpty) {
      throw AuthenticationException(errorMessage);
    }
    return;
  }

  @override
  Future<User> signInWithGoogle() async {
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
      return UserModel.fromFirebaseUser(authResult.user);
    } catch (e) {
      throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token');
    }
  }

  // @override
  // Future<User> signInWithFacebook() async {
  //   final FacebookLogin facebookLogin = FacebookLogin();
  //   // https://github.com/roughike/flutter_facebook_login/issues/210
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

  @override
  Future<bool> isUsernameValid(String username) async {
    final DocumentSnapshot result =
        await store.document(FirestorePath.users(username)).get();
    return result != null;
  }
}
