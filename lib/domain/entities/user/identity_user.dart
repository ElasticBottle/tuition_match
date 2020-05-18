import 'package:cotor/domain/entities/post/base_post/base_identity/account_type.dart';
import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/name.dart';

class IdentityUser extends Equatable implements IdentityBase {
  const IdentityUser({
    Name name,
    String photoUrl,
    String uid,
    AccountType accountType,
    bool isEmailVerified,
  })  : _name = name,
        _photoUrl = photoUrl,
        _uid = uid,
        _accountType = accountType,
        _isEmailVerified = isEmailVerified;

  final Name _name;
  final String _photoUrl;
  final String _uid;
  final AccountType _accountType;

  final bool _isEmailVerified;

  @override
  Name get name => _name;

  @override
  String get photoUrl => _photoUrl;

  @override
  String get uid => _uid;

  @override
  AccountType get accountType => _accountType;

  bool get isVerifiedAccount => _accountType.isVerAcc();

  bool get isEmailVerified => _isEmailVerified;

  @override
  List<Object> get props => [
        name,
        photoUrl,
        uid,
        accountType,
        accountType,
        isEmailVerified,
      ];

  @override
  String toString() {
    return '''IdentityUser(
      name: $name, 
      photoUrl: $photoUrl, 
      uid: $uid, 
      accountType: $accountType, 
      accountType: $accountType, 
      isEmailVerified: $isEmailVerified
    )''';
  }
}
