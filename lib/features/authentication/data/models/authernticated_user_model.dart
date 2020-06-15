import 'package:cotor/data/models/map_key_strings.dart' as MapKey;
import 'package:cotor/domain/entities/user/user_export.dart';
import 'package:cotor/features/authentication/domain/entities/authenticated_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticatedUserModel extends AuthenticatedUser {
  AuthenticatedUserModel({String uid, String photoUrl, bool isEmailVerified})
      : super(uid: uid, photoUrl: photoUrl, isEmailVerified: isEmailVerified);
  factory AuthenticatedUserModel.fromFirebaseUser(FirebaseUser user) {
    if (user == null) {
      return AuthenticatedUserModel(
        photoUrl: '',
        uid: '',
        isEmailVerified: false,
      );
    }
    return AuthenticatedUserModel(
      photoUrl: user.photoUrl,
      uid: user.uid,
      isEmailVerified: user.isEmailVerified,
    );
  }

  AuthenticatedUser toDomainEntity() {
    return AuthenticatedUser(
      isEmailVerified: isEmailVerified,
      uid: uid,
      photoUrl: photoUrl,
    );
  }

  static Map<String, dynamic> toNewUserDocumentMap(
    String firstName,
    String lastName,
    String url,
  ) {
    return <String, dynamic>{
      MapKey.USER_IDENTITY: <String, dynamic>{
        MapKey.NAME: <String, String>{
          MapKey.FIRSTNAME: firstName,
          MapKey.LASTNAME: lastName,
        },
        MapKey.PHOTO_URL: url,
        MapKey.ACCOUNT_TYPE: AccountType.BASIC.toString(),
      },
      MapKey.USER_ASSIGNMENTS: <String, Map<String, dynamic>>{},
      MapKey.USER_PROFILE: <String, dynamic>{},
    };
  }

  static Map<String, dynamic> toContactInfoMap(String phone, String code) {
    return <String, dynamic>{
      MapKey.PHONE_NUMBER: phone,
      MapKey.COUNTRY_CODE: code,
    };
  }
}
