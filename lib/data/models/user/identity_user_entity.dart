import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_identity/name_entity.dart';
import 'package:cotor/data/models/user/account_type_entity.dart';
import 'package:cotor/domain/entities/user/identity_user.dart';

class IdentityUserEntity extends IdentityUser
    implements EntityBase<IdentityUser> {
  const IdentityUserEntity({
    bool isEmailVerified,
    AccountTypeEntity accountType,
    NameEntity name,
    String photoUrl,
    String uid,
  })  : _name = name,
        _accountType = accountType,
        super(
          isEmailVerified: isEmailVerified,
          accountType: accountType,
          name: name,
          photoUrl: photoUrl,
          uid: uid,
        );

  factory IdentityUserEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return IdentityUserEntity(
      accountType: AccountTypeEntity.fromString(json[ACCOUNT_TYPE]),
      isEmailVerified: json[IS_EMAIL_VERIFIED],
      name: NameEntity.fromJson(json[NAME]),
      photoUrl: json[PHOTO_URL],
      uid: json[UID],
    );
  }

  factory IdentityUserEntity.fromDomainEntity(IdentityUser userIdentity) {
    if (userIdentity == null) {
      return null;
    }
    return IdentityUserEntity(
      isEmailVerified: userIdentity.isEmailVerified,
      accountType: AccountTypeEntity.fromDomainEntity(userIdentity.accountType),
      name: NameEntity.fromDomainEntity(userIdentity.name),
      photoUrl: userIdentity.photoUrl,
      uid: userIdentity.uid,
    );
  }

  final NameEntity _name;
  final AccountTypeEntity _accountType;
  @override
  NameEntity get name => _name;

  @override
  AccountTypeEntity get accountType => _accountType;

  Map<String, dynamic> toFirebaesMap() {
    return <String, dynamic>{
      ACCOUNT_TYPE: accountType.toString(),
      NAME: name.toJson(),
      PHOTO_URL: photoUrl,
    };
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ACCOUNT_TYPE: accountType.toString(),
      IS_EMAIL_VERIFIED: isEmailVerified,
      NAME: name.toJson(),
      PHOTO_URL: photoUrl,
      UID: uid,
    };
  }

  @override
  IdentityUser toDomainEntity() {
    return IdentityUser(
      accountType: accountType?.toDomainEntity(),
      isEmailVerified: isEmailVerified,
      name: name?.toDomainEntity(),
      photoUrl: photoUrl,
      uid: uid,
    );
  }

  @override
  String toString() {
    return '''IdentityUserEntity(
      name: $name, 
      photoUrl: $photoUrl, 
      uid: $uid, 
      accountType: $accountType, 
      isEmailVerified: $isEmailVerified
    )''';
  }
}
