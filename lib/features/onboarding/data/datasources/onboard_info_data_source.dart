import 'package:firebase_auth_demo_flutter/features/onboarding/data/models/onboard_info_model.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';

abstract class OnboardInfoDataSource {
  Future<OnboardInfoModel> getOnbaordInfo(ScreenNumber number);
}
