import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo_flutter/core/error/failures.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/material.dart';

class getOnboardingInfo {
  getOnboardingInfo({this.repository});
  OnboardingRepository repository;

  Future<Either<Failure, OnboardInfo>> call(
      {@required ScreenNumber screenNumber}) async {
    return await repository.getOnboardingInfo(screenNumber);
  }
}
