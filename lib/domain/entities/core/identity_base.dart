import 'package:cotor/domain/entities/post/base_post/base_identity/account_type.dart';
import 'package:cotor/domain/entities/post/base_post/base_identity/name.dart';

abstract class IdentityBase {
  Name get name;
  String get photoUrl;
  String get uid;
  AccountType get accountType;
}
