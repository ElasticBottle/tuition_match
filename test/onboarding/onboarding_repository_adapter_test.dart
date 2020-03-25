import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo_flutter/core/error/exception.dart';
import 'package:firebase_auth_demo_flutter/core/error/failures.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/data/datasources/onboard_info_data_source.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/data/models/onboard_info_model.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/data/repositories/onboarding_repository_adapter.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockOnboardInfoDataSource extends Mock implements OnboardInfoDataSource {}

void main() {
  MockOnboardInfoDataSource dataSource;
  OnboardingRepositoryAdapter repo;

  setUp(() {
    dataSource = MockOnboardInfoDataSource();
    repo = OnboardingRepositoryAdapter(dataSource: dataSource);
  });

  group('getOnboardInfo', () {
    // Results to compare against
    const ScreenNumber number = ScreenNumber.zero;
    final OnboardInfoModel tOnBoardInfoModel = OnboardInfoModel(
        title: 'test', description: 'desc', image: AssetImage(''));
    final OnboardInfo tOnboardInfo = tOnBoardInfoModel;

    test('Files for Onboard present', () async {
      // Arrange
      when(dataSource.getOnbaordInfo(any))
          .thenAnswer((realInvocation) async => tOnBoardInfoModel);
      // Act
      final result = await repo.getOnboardingInfo(number);
      // Assert
      verify(dataSource.getOnbaordInfo(number));
      expect(result, equals(Right<Failure, OnboardInfo>(tOnboardInfo)));
    });

    test('Files for Onboard not present', () async {
      // Arrange
      when(dataSource.getOnbaordInfo(any)).thenThrow(FileException());
      // Act
      final result = await repo.getOnboardingInfo(number);
      // Assert
      verify(dataSource.getOnbaordInfo(number));
      expect(result, equals(Left<Failure, OnboardInfo>(FileFailure())));
    });
  });
}
