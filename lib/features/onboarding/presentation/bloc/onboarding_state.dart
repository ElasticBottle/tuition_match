import 'package:equatable/equatable.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:flutter/material.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
}

class InitialOnboardingState extends OnboardingState {
  @override
  List<Object> get props => [];
}

class Loading extends OnboardingState {
  @override
  List<Object> get props => [];
}

class Loaded extends OnboardingState {
  const Loaded({@required this.info});
  final OnboardInfo info;

  @override
  List<Object> get props => [info];
}

class Error extends OnboardingState {
  const Error({@required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
