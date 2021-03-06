import 'package:equatable/equatable.dart';
import 'package:cotor/features/onboarding/domain/entities/onboard_info.dart';
import 'package:flutter/material.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
}

class InitialOnboardingState extends OnboardingState {
  const InitialOnboardingState({this.total});
  final int total;
  @override
  List<Object> get props => [total];
}

class Loading extends OnboardingState {
  @override
  List<Object> get props => [];
}

class Loaded extends OnboardingState {
  const Loaded({@required this.info, this.current});
  final OnboardInfo info;
  final int current;

  @override
  List<Object> get props => [info];
}

class Error extends OnboardingState {
  const Error({@required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
