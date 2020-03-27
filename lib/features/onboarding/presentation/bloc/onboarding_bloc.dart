import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/onboarding/domain/entities/onboard_info.dart';
import 'package:cotor/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:cotor/features/onboarding/presentation/bloc/bloc.dart';
import 'package:cotor/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/material.dart';

const String FILE_FAILURE_MESSAGE = 'File Failure';
const String UNEXPECTED_FAILURE_MESSAGE = 'Unexpected Failure';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({@required this.getOnboardingInfo})
      : assert(getOnboardingInfo != null);

  final GetOnboardingInfo getOnboardingInfo;

  @override
  OnboardingState get initialState => InitialOnboardingState(
        total: getOnboardingInfo.total(),
      );

  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    if (event is GetNextOnboardingInfo) {
      yield Loading();
      final failureOrOnboardInfo = await getOnboardingInfo(
          Params(screenNumber: ScreenNumber.values[event.index]));
      yield failureOrOnboardInfo.fold(
          (Failure failure) => Error(message: _mapFailureToMessage(failure)),
          (OnboardInfo onboardInfo) => Loaded(
                info: onboardInfo,
                current: getOnboardingInfo.current(),
              ));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case FileFailure:
        return FILE_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
