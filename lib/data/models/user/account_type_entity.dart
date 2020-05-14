import 'package:cotor/data/models/entity_base.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/account_type.dart';

class AccountTypeEntity extends AccountType implements EntityBase<AccountType> {
  const AccountTypeEntity(String type) : super(type);

  factory AccountTypeEntity.fromString(String value) {
    return AccountTypeEntity(value);
  }

  factory AccountTypeEntity.fromDomainEntity(AccountType entity) {
    return AccountTypeEntity(entity.accountType);
  }

  @override
  AccountType toDomainEntity() {
    return AccountType(accountType);
  }
}
