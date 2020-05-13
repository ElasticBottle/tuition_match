import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_identity/name_entity.dart';
import 'package:cotor/data/models/post/base_post/gender_entity.dart';
import 'package:cotor/data/models/user/account_type_entity.dart';
import 'package:cotor/domain/entities/post/tutor_profile/identity/identity_tutor.dart';

class IdentityTutorEntity extends IdentityTutor
    implements EntityBase<IdentityTutor> {
  const IdentityTutorEntity({
    String photoUrl,
    String uid,
    NameEntity name,
    GenderEntity gender,
    bool isOpen,
    AccountTypeEntity accountType,
  })  : _name = name,
        _gender = gender,
        _accountType = accountType,
        super(
          photoUrl: photoUrl,
          uid: uid,
          name: name,
          gender: gender,
          isOpen: isOpen,
          accountType: accountType,
        );

  factory IdentityTutorEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return IdentityTutorEntity(
      photoUrl: json[PHOTO_URL],
      uid: json[UID],
      name: NameEntity.fromJson(json[NAME]),
      gender: GenderEntity.fromShortString(json[GENDER]),
      isOpen: json[IS_OPEN],
      accountType: AccountTypeEntity.fromString(json[ACCOUNT_TYPE]),
    );
  }

  factory IdentityTutorEntity.fromDomainEntity(IdentityTutor entity) {
    return IdentityTutorEntity(
      photoUrl: entity.photoUrl,
      uid: entity.uid,
      name: NameEntity.fromDomainEntity(entity.name),
      gender: GenderEntity.fromDomainEntity(entity.gender),
      isOpen: entity.isOpen,
      accountType: AccountTypeEntity.fromDomainEntity(entity.accountType),
    );
  }

  final NameEntity _name;
  final GenderEntity _gender;
  final AccountTypeEntity _accountType;

  @override
  NameEntity get name => _name;

  @override
  GenderEntity get gender => _gender;

  @override
  AccountTypeEntity get accountType => _accountType;

  @override
  IdentityTutor toDomainEntity() {
    return IdentityTutor(
      photoUrl: photoUrl,
      uid: uid,
      name: name.toDomainEntity(),
      gender: gender.toDomainEntity(),
      isOpen: isOpen,
      accountType: accountType.toDomainEntity(),
    );
  }

  /// Same as toJson but less [uid] field
  Map<String, dynamic> toFirebaseMap() {
    return <String, dynamic>{
      PHOTO_URL: photoUrl,
      NAME: name.toJson(),
      GENDER: gender.toShortString(),
      IS_OPEN: isOpen,
      ACCOUNT_TYPE: accountType.toString(),
    };
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      UID: uid,
      PHOTO_URL: photoUrl,
      NAME: name.toJson(),
      GENDER: gender.toShortString(),
      IS_OPEN: isOpen,
      ACCOUNT_TYPE: accountType.toString(),
    };
  }

  @override
  String toString() {
    return '''IdentityTutorEntity(
      photoUrl: $photoUrl,
      uid: $uid, 
      name: $name, 
      gender: $gender, 
      isOpen: $isOpen, 
      accountType: $accountType
    )''';
  }
}
