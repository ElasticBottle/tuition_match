import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo_flutter/core/error/failures.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  getOnboardingInfo usecase;
  MockOnboardingRepository mockRepo;

  setUp(() {
    mockRepo = MockOnboardingRepository();
    usecase = getOnboardingInfo(repository: mockRepo);
  });

  const ScreenNumber testScreenNumber = ScreenNumber.one;
  const OnboardInfo testOnboardInfo =
      OnboardInfo(title: 'test', description: 'test', image: null);
  test(
    'should get onboarding info for the screenNumber from the repository',
    () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteNumberTrivia is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(mockRepo.getOnboardingInfo(any)).thenAnswer(
          (_) async => Right<Failure, OnboardInfo>(testOnboardInfo));
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase(screenNumber: testScreenNumber);
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right<Failure, OnboardInfo>(testOnboardInfo));
      // Verify that the method has been called on the Repository
      verify(mockRepo.getOnboardingInfo(testScreenNumber));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockRepo);
    },
  );
}
