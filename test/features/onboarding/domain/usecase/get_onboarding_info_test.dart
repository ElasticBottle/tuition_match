import 'package:dartz/dartz.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/onboarding/domain/entities/onboard_info.dart';
import 'package:cotor/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:cotor/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  GetOnboardingInfo usecase;
  MockOnboardingRepository mockRepo;

  setUp(() {
    mockRepo = MockOnboardingRepository();
    usecase = GetOnboardingInfo(repository: mockRepo);
  });

  const ScreenNumber testScreenNumber = ScreenNumber.zero;
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
      final result = await usecase.next();
      await usecase.next();
      await usecase.next();
      await usecase.next();

      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right<Failure, OnboardInfo>(testOnboardInfo));
      expect(usecase.screenNum, ScreenNumber.end);

      // Verify that the method has been called on the Repository
      verify(mockRepo.getOnboardingInfo(testScreenNumber)).called(1);
      verify(mockRepo.getOnboardingInfo(ScreenNumber.one)).called(1);
      verify(mockRepo.getOnboardingInfo(ScreenNumber.two)).called(1);
      verify(mockRepo.getOnboardingInfo(ScreenNumber.three)).called(1);
      verifyNoMoreInteractions(mockRepo);
    },
  );

  test(
      'Total screen retrieved should be the same as number of values in ScreenNumber',
      () {
    final int result = usecase.total();

    expect(result, ScreenNumber.end.index);
  });

  test('Index should increment after being called', () async {
    when(mockRepo.getOnboardingInfo(any))
        .thenAnswer((_) async => Right<Failure, OnboardInfo>(testOnboardInfo));

    expect(testScreenNumber.index, usecase.current());
    // The "act" phase of the test. Call the not-yet-existent method.
    await usecase.next();

    expect(testScreenNumber.index + 1, usecase.current());
  });
}
