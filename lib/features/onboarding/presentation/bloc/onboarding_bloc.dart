import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  @override
  OnboardingState get initialState => InitialOnboardingState();

  @override
  Stream<OnboardingState> mapEventToState(
    OnboardingEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
