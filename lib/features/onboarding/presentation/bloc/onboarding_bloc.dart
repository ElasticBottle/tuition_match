import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/usecases/get_onboarding_info.dart';
import 'package:flutter/material.dart';
import './bloc.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({@required this.getOnboardingInfo})
      : assert(getOnboardingInfo != null);

  final GetOnboardingInfo getOnboardingInfo;

  @override
  OnboardingState get initialState => InitialOnboardingState();

  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    if (event is GetNextOnboardingInfo) {
      getOnboardingInfo.next();
    }
  }
}
