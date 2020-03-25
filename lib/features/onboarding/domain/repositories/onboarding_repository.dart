import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo_flutter/core/error/failures.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';

enum ScreenNumber {
  zero,
  one,
  two,
  three,
}

abstract class OnboardingRepository {
  Future<Either<Failure, OnboardInfo>> getOnboardingInfo(ScreenNumber number);
}
