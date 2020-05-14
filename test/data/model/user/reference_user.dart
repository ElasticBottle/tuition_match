import 'package:cotor/data/models/post/base_post/base_identity/name_entity.dart';
import 'package:cotor/data/models/user/account_type_entity.dart';
import 'package:cotor/data/models/user/identity_user_entity.dart';
import 'package:cotor/data/models/user/user_entity.dart';
import 'package:cotor/domain/entities/user/user_export.dart';

import '../tutee/reference_assignment.dart';
import '../tutor/reference_profile.dart';

class ReferenceUser {
  ReferenceUser();

  static final IdentityUser testIdentityUser = IdentityUser(
    accountType: AccountType.BASIC,
    isEmailVerified: null,
    name: Name(
      firstName: 'John',
      lastName: 'Tan',
    ),
    photoUrl:
        'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
    uid: '12345',
  );

  static final IdentityUserEntity testIdentityUserEntity = IdentityUserEntity(
    accountType: AccountTypeEntity.fromDomainEntity(AccountType.BASIC),
    isEmailVerified: null,
    name: NameEntity(
      firstName: 'John',
      lastName: 'Tan',
    ),
    photoUrl:
        'https://secure.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
    uid: '12345',
  );

  static final User testUser = User(
    identity: testIdentityUser,
    assignments: {
      ReferenceAssignment.testAssignment.postId:
          ReferenceAssignment.testAssignment
    },
    profile: ReferenceProfile.testProfile,
  );
  static final UserEntity testUserEntity = UserEntity(
    identity: testIdentityUserEntity,
    assignments: {
      ReferenceAssignment.testAssignmentEntity.postId:
          ReferenceAssignment.testAssignmentEntity
    },
    profile: ReferenceProfile.testProfileEntity,
  );
}
