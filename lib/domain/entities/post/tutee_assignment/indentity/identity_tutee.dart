import 'package:cotor/domain/entities/core/identity_base.dart';

abstract class IdentityTutee extends IdentityBase {
  String get postId;
  bool get isOpen;
  bool get isPublic;
}
