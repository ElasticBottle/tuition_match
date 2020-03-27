import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();
}

class GetNextOnboardingInfo extends OnboardingEvent {
  const GetNextOnboardingInfo({this.index});
  final int index;
  @override
  List<Object> get props => [];
}
