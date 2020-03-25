import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:flutter/cupertino.dart';

class OnboardInfoModel extends OnboardInfo {
  const OnboardInfoModel({
    @required String title,
    @required String description,
    AssetImage image,
  }) : super(
          title: title,
          description: description,
          image: image,
        );
}
