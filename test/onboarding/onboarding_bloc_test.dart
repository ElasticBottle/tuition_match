import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo_flutter/core/error/failures.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockOnboardingInfo extends Mock implements GetOnboardingInfo {}

void main() {
  OnboardingBloc bloc;
  MockOnboardingInfo mockOnboardInfo;

  setUp(() {
    mockOnboardInfo = MockOnboardingInfo();
    bloc = OnboardingBloc(getOnboardingInfo: mockOnboardInfo);
  });

  test('initial state should be IniitialOnboardingState', () {
    expect(bloc.initialState, InitialOnboardingState());
  });

  group('GetOnboardingInfo Event', () {
    final OnboardInfo tOnboardInfo =
        OnboardInfo(title: 'test', description: 'desc', image: null);

    void _setUpMockUseCaseSuccess() {
      when(mockOnboardInfo.next()).thenAnswer(
          (realInvocation) async => Right<Failure, OnboardInfo>(tOnboardInfo));
    }

    test('Should call GetNextOnboardingInfo', () async {
      _setUpMockUseCaseSuccess();

      bloc.add(GetNextOnboardingInfo());
      await untilCalled(mockOnboardInfo.next());

      verify(mockOnboardInfo.next());
    });

    test(
        'Should return Loading and Loaded state on successful retrieval of files',
        () async {
      _setUpMockUseCaseSuccess();
      // assert later
      final expected = [
        InitialOnboardingState(),
        Loading(),
        Loaded(info: tOnboardInfo),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetNextOnboardingInfo());
    });
    test(
        'Should return Loading and Error state on unsuccessful retrieval of files',
        () async {
      when(mockOnboardInfo.next())
          .thenAnswer((_) async => Left<Failure, OnboardInfo>(FileFailure()));
      // assert later
      final expected = [
        InitialOnboardingState(),
        Loading(),
        Error(message: FILE_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));
      // act
      bloc.add(GetNextOnboardingInfo());
    });
  });
}
