import 'package:cotor/domain/entities/user/account_type.dart';
import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/name.dart';

class IdentityUser extends Equatable implements IdentityBase {
  const IdentityUser({
    Name name,
    String photoUrl,
    String uid,
    AccountType accountType,
    bool isVerifiedAccount,
    bool isEmailVerified,
  })  : _name = name,
        _photoUrl = photoUrl,
        _uid = uid,
        _accountType = accountType,
        _isVerifiedAccount = isVerifiedAccount,
        _isEmailVerified = isEmailVerified;

  final Name _name;
  final String _photoUrl;
  final String _uid;
  final AccountType _accountType;
  final bool _isVerifiedAccount;
  final bool _isEmailVerified;

  @override
  Name get name => _name;

  @override
  String get photoUrl => _photoUrl;

  @override
  String get uid => _uid;

  AccountType get accountType => _accountType;
  bool get isVerifiedAccount => _isVerifiedAccount;
  bool get isEmailVerified => _isEmailVerified;

  @override
  List<Object> get props => [
        name,
        photoUrl,
        uid,
        accountType,
        isVerifiedAccount,
        isEmailVerified,
      ];

  @override
  String toString() {
    return '''IdentityUser(
      name: $name, 
      photoUrl: $photoUrl, 
      uid: $uid, 
      accountType: $accountType, 
      isVerifiedAccount: $isVerifiedAccount, 
      isEmailVerified: $isEmailVerified
    )''';
  }
}
