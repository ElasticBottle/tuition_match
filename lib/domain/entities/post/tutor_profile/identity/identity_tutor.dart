import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/account_type.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/name.dart';
import 'package:cotor/domain/entities/post/base_post/gender.dart';

class IdentityTutor extends Equatable implements IdentityBase {
  const IdentityTutor({
    @required String photoUrl,
    @required String uid,
    @required Name name,
    @required Gender gender,
    @required bool isOpen,
    @required AccountType accountType,
  })  : _photoUrl = photoUrl,
        _uid = uid,
        _name = name,
        _gender = gender,
        _isOpen = isOpen,
        _accountType = accountType;

  final String _photoUrl;
  final String _uid;
  final Name _name;
  final Gender _gender;
  final bool _isOpen;
  final AccountType _accountType;

  @override
  String get photoUrl => _photoUrl;

  @override
  String get uid => _uid;

  @override
  Name get name => _name;

  Gender get gender => _gender;

  bool get isOpen => _isOpen;

  @override
  AccountType get accountType => _accountType;

  bool get isVerifiedTutor => _accountType.isVerTutor();

  @override
  List<Object> get props => [
        _photoUrl,
        _uid,
        _name,
        _gender,
        _isOpen,
        _accountType,
      ];

  @override
  String toString() {
    return '''IdentityTutor(
      photoUrl: $photoUrl,
      uid: $uid, 
      name: $name, 
      gender: $gender, 
      isOpen: $isOpen, 
      accountType: $accountType
    )''';
  }
}
