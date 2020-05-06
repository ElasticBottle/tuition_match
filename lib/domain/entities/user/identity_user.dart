import 'package:cotor/domain/entities/core/identity_base.dart';

abstract class IdentityUser extends IdentityBase {
  bool get isVerifiedTutor;
  bool get isTutor;
  bool get isVerifiedAccount;
  bool get isEmailVerified;
}
