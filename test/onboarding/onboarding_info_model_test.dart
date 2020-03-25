import 'package:firebase_auth_demo_flutter/features/onboarding/data/models/onboard_info_model.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fixtures/fixture_reader.dart';

void main() {
  final tOnboardingInfoModel =
      OnboardInfoModel(title: 'test', description: 'body', image: null);

  test('should be a subclass of OnboardInfo entitiy', () async {
    expect(tOnboardingInfoModel, isA<OnboardInfo>());
  });

  test(
      'Should convert text file'
      'WITH title in first line'
      'FOLLOWED BY newline'
      'AND description in remainder of txt file'
      'Into appropriate Title and Description'
      'WITH image as null', () {
    // arrange
    final String details = fixture('onboardInfoSample.txt');

    // act
    final OnboardInfoModel result = OnboardInfoModel.fromString(details);

    // assert
    expect(result, tOnboardingInfoModel);
  });
}
