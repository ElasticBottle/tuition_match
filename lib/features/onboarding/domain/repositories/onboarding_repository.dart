import 'package:dartz/dartz.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/onboarding/domain/entities/onboard_info.dart';

enum ScreenNumber {
  zero,
  one,
  two,
  three,
  end,
}

abstract class OnboardingRepository {
  Future<Either<Failure, OnboardInfo>> getOnboardingInfo(ScreenNumber number);
}
