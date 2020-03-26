import 'package:firebase_auth_demo_flutter/core/error/exception.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/data/datasources/onboard_info_data_source.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/data/models/onboard_info_model.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../fixtures/fixture_reader.dart';

class MockRootBundle extends Mock implements AssetBundle {}

void main() {
  MockRootBundle assetBundle;
  OnboardInfoDataSource data;

  setUp(() {
    assetBundle = MockRootBundle();
    data = OnboardInfoDataSourceImpl(assetBundle);
  });

  test('Retrieves an OnboardInfo', () async {
    const ScreenNumber tScreenNum = ScreenNumber.zero;
    final OnboardInfoModel tOnboardInfoModel = OnboardInfoModel(
        title: 'test',
        description: 'body\nof description',
        image: AssetImage(''));

    // Arrange
    when(assetBundle.loadString(any)).thenAnswer(
        (realInvocation) => Future.value(fixture('onboardInfoSample.txt')));

    // Act
    final result = await data.getOnbaordInfo(tScreenNum);

    // Assert
    expect(result, equals(tOnboardInfoModel));
    verify(assetBundle.loadString(any));
    verifyNoMoreInteractions(assetBundle);
  });

  test('Not able to retrieve OnboardInfo', () async {
    const ScreenNumber tScreenNum = ScreenNumber.zero;
    final OnboardInfoModel tOnboardInfoModel = OnboardInfoModel(
        title: 'test',
        description: 'body\nof description',
        image: AssetImage(''));

    // Arrange
    when(assetBundle.loadString(any)).thenThrow(FileException());

    // Act
    final result = await data.getOnbaordInfo(tScreenNum);

    // Assert
    expect(result, equals(tOnboardInfoModel));
    verify(assetBundle.loadString(any));
    verifyNoMoreInteractions(assetBundle);
  });
}
