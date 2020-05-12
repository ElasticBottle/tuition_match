import 'package:cotor/features/onboarding/data/models/onboard_info_model.dart';
import 'package:cotor/features/onboarding/domain/entities/onboard_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tOnboardingInfoModel = OnboardInfoModel(
      title: 'test', description: 'body\nof description', image: null);

  final tOnboardInfoModelWithImage = OnboardInfoModel(
      title: 'test',
      description: 'body\nof description',
      image: AssetImage(''));
  test('should be a subclass of OnboardInfo entitiy', () async {
    expect(tOnboardingInfoModel, isA<OnboardInfo>());
  });

  group('Loading from files', () {
    test(
        'Should convert text file '
        'WITH title in first line '
        'FOLLOWED BY newline '
        'AND description in remainder of txt file '
        'Into appropriate Title and Description '
        'WITH image as null', () {
      // arrange
      final String details = fixture('onboardInfoSample.txt');

      // act
      final OnboardInfoModel result = OnboardInfoModel.fromString(details);

      // assert
      expect(result.title, tOnboardingInfoModel.title);
      expect(result.description, tOnboardingInfoModel.description);
    });
    test('As above with image loaded as well', () {
      // Arrange
      final String details = fixture('onboardInfoSample.txt');
      final AssetImage image = AssetImage('');

      // Act
      final OnboardInfoModel result =
          OnboardInfoModel.fromStringAndImage(details, image);

      // Assert
      expect(result, tOnboardInfoModelWithImage);
    });
  });
}
