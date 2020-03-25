import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo_flutter/core/error/failures.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/material.dart';

class getOnboardingInfo {
  getOnboardingInfo({this.repository});
  OnboardingRepository repository;
  ScreenNumber screenNum = ScreenNumber.zero;

  Future<Either<Failure, OnboardInfo>> call(
      {@required ScreenNumber screenNumber}) async {
    return await repository.getOnboardingInfo(screenNumber);
  }

  /// Returns current OnboardingInfo and increments the ScreenNumber
  /// so that the next OnboardingInfo can be retrieved
  Future<Either<Failure, OnboardInfo>> next() async {
    final result = await repository.getOnboardingInfo(screenNum);
    if (screenNum.index < ScreenNumber.values.length - 1) {
      screenNum = ScreenNumber.values[screenNum.index + 1];
    } else {
      screenNum = ScreenNumber.zero;
    }
    return result;
  }
}
