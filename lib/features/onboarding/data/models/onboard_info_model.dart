import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:flutter/cupertino.dart';

const String titleKey = 'title';
const String descKey = 'descripetion';

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
        title: results[titleKey], description: results[descKey], image: image);
  }

  factory OnboardInfoModel.fromString(String details) {
    final Map<String, String> results = _parseStringDetails(details);

    return OnboardInfoModel(
        title: results[titleKey], description: results[descKey], image: null);
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

    return {titleKey: title, descKey: description};
  }
}
