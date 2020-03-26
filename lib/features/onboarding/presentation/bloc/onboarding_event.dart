import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class GetNextOnboardingInfo extends OnboardingEvent {
  @override
  List<Object> get props => [];
}
