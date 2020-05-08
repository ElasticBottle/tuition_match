import 'package:equatable/equatable.dart';

import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/name.dart';
import 'package:cotor/domain/entities/post/base_post/gender.dart';

class IdentityTutor extends Equatable implements IdentityBase {
  const IdentityTutor({
    String photoUrl,
    String uid,
    Name name,
    Gender gender,
    bool isOpen,
    bool isVerifiedTutor,
  })  : _photoUrl = photoUrl,
        _uid = uid,
        _name = name,
        _gender = gender,
        _isOpen = isOpen,
        _isVerifiedTutor = isVerifiedTutor;

  final String _photoUrl;
  final String _uid;
  final Name _name;
  final Gender _gender;
  final bool _isOpen;
  final bool _isVerifiedTutor;

  @override
  String get photoUrl => _photoUrl;

  @override
  String get uid => _uid;

  @override
  Name get name => _name;

  Gender get gender => _gender;

  bool get isOpen => _isOpen;

  bool get isVerifiedTutor => _isVerifiedTutor;

  @override
  List<Object> get props => [
        _photoUrl,
        _uid,
        _name,
        _gender,
        _isOpen,
        _isVerifiedTutor,
      ];

  @override
  String toString() {
    return '''IdentityTutor(
      photoUrl: $photoUrl,
      uid: $uid, 
      name: $name, 
      gender: $gender, 
      isOpen: $isOpen, 
      isVerifiedTutor: $isVerifiedTutor
    )''';
  }
}
