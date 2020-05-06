import 'package:cotor/domain/entities/core/identity_base.dart';
import 'package:cotor/domain/entities/post/base_post/gender.dart';

abstract class IdentityTutor extends IdentityBase {
  Gender get gender;
  bool get isVerifiedtutor;
}
