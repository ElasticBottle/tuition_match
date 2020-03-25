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

  factory OnboardInfoModel.fromStringAndImage(
      String details, AssetImage image) {
    final Map<String, String> results = _parseStringDetails(details);
    return OnboardInfoModel(
        title: results[Keys.title],
        description: results[Keys.desc],
        image: image);
  }

  factory OnboardInfoModel.fromString(String details) {
    final Map<String, String> results = _parseStringDetails(details);

    return OnboardInfoModel(
        title: results[Keys.title],
        description: results[Keys.desc],
        image: null);
  }

  static Map<String, String> _parseStringDetails(String details) {
    final List<String> split = details.split(RegExp('\n'));
    // Removes "\r" from characters after newline
    for (int i = 0; i < split.length - 1; i++) {
      split[i] = split[i].substring(0, split[i].length - 1);
    }
    final String title = split[0];
    // Joins remainder of List<String> into one String for description.
    // Newline between the strings is preserved
    final String description = split.sublist(2).join('\n');

    return {Keys.title: title, Keys.desc: description};
  }
}

class Keys {
  static String titleKey = 'title';
  static String descKey = 'descripetion';

  static String get title => titleKey;
  static String get desc => descKey;
}
