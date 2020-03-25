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

  factory OnboardInfoModel.fromString(String details) {
    final List<String> split = details.split(RegExp('\n'));
    for (int i = 0; i < split.length - 1; i++) {
      split[i] = split[i].substring(0, split[i].length - 1);
    }
    final String title = split[0];
    final String description = split.sublist(2).join('\n');

    return OnboardInfoModel(
        title: title, description: description, image: null);
  }
}
