import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
}

class InitialOnboardingState extends OnboardingState {
  @override
  List<Object> get props => [];
}
