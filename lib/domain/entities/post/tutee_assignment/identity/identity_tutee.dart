import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/account_type.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/name.dart';
import 'package:equatable/equatable.dart';

class IdentityTutee extends Equatable implements IdentityBase {
  const IdentityTutee(
      {String photoUrl,
      String postId,
      String uid,
      Name name,
      bool isOpen,
      bool isPublic,
      AccountType accountType})
      : _photoUrl = photoUrl,
        _postId = postId,
        _uid = uid,
        _name = name,
        _isOpen = isOpen,
        _isPublic = isPublic,
        _accountType = accountType;

  final String _photoUrl;
  final String _postId;
  final String _uid;
  final Name _name;
  final bool _isOpen;
  final bool _isPublic;
  final AccountType _accountType;
  @override
  String get photoUrl => _photoUrl;

  String get postId => _postId;

  @override
  String get uid => _uid;

  @override
  Name get name => _name;

  bool get isOpen => _isOpen;

  bool get isPublic => _isPublic;

  @override
  AccountType get accountType => _accountType;

  bool get isVerifiedAccount => _accountType.isVerAcc();

  @override
  List<Object> get props => [
        _photoUrl,
        _postId,
        _uid,
        _name,
        _isOpen,
        _isPublic,
        _accountType,
      ];

  @override
  String toString() => '''IdentityTutee(
      photoUrl: $photoUrl,
      postId: $postId,
      uid: $uid,
      name: $name,
      isOpen: $isOpen,
      isPublic: $isPublic,
      accountType: $accountType
    )''';
}
