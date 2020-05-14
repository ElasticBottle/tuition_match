import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/base_post/base_identity/name_entity.dart';
import 'package:cotor/data/models/user/account_type_entity.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/identity/identity_tutee.dart';

class IdentityTuteeEntity extends IdentityTutee
    implements EntityBase<IdentityTutee> {
  const IdentityTuteeEntity({
    String photoUrl,
    String postId,
    String uid,
    NameEntity name,
    bool isOpen,
    bool isPublic,
    AccountTypeEntity accountType,
  })  : _name = name,
        _accountType = accountType,
        super(
          photoUrl: photoUrl,
          postId: postId,
          uid: uid,
          name: name,
          isOpen: isOpen,
          isPublic: isPublic,
          accountType: accountType,
        );

  factory IdentityTuteeEntity.fromJson(Map<String, dynamic> json) {
    if (json == null || json.isEmpty) {
      return null;
    }
    return IdentityTuteeEntity(
      photoUrl: json[PHOTO_URL],
      postId: json[POST_ID],
      uid: json[UID],
      name: NameEntity.fromJson(json[NAME]),
      isOpen: json[IS_OPEN],
      isPublic: json[IS_PUBLIC],
      accountType: AccountTypeEntity.fromString(json[ACCOUNT_TYPE]),
    );
  }
  factory IdentityTuteeEntity.fromDomainEntity(IdentityTutee entity) {
    return IdentityTuteeEntity(
      photoUrl: entity.photoUrl,
      postId: entity.postId,
      uid: entity.uid,
      name: NameEntity.fromDomainEntity(entity.name),
      isOpen: entity.isOpen,
      isPublic: entity.isPublic,
      accountType: AccountTypeEntity.fromDomainEntity(entity.accountType),
    );
  }

  final NameEntity _name;
  final AccountTypeEntity _accountType;

  @override
  NameEntity get name => _name;

  @override
  AccountTypeEntity get accountType => _accountType;

  @override
  IdentityTutee toDomainEntity() {
    return IdentityTutee(
      photoUrl: photoUrl,
      postId: postId,
      uid: uid,
      name: name.toDomainEntity(),
      isOpen: isOpen,
      isPublic: isPublic,
      accountType: accountType.toDomainEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      PHOTO_URL: photoUrl,
      POST_ID: postId,
      UID: uid,
      NAME: name.toJson(),
      IS_OPEN: isOpen,
      IS_PUBLIC: isPublic,
      ACCOUNT_TYPE: accountType.toString()
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return <String, dynamic>{
      PHOTO_URL: photoUrl,
      UID: uid,
      NAME: name.toJson(),
      IS_OPEN: isOpen,
      IS_PUBLIC: isPublic,
      ACCOUNT_TYPE: accountType.toString()
    };
  }

  @override
  String toString() => '''IdentityTuteeEntity(
      photoUrl: $photoUrl,
      postId: $postId,
      uid: $uid,
      name: $name,
      isOpen: $isOpen,
      isPublic: $isPublic,
      accountType: $accountType,
    )''';
}
