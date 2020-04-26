import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/onboarding/domain/entities/onboard_info.dart';
import 'package:cotor/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/material.dart';

class GetOnboardingInfo extends UseCase<OnboardInfo, Params> {
  GetOnboardingInfo({this.repository});
  OnboardingRepository repository;
  ScreenNumber screenNum = ScreenNumber.zero;

  @override
  Future<Either<Failure, OnboardInfo>> call(Params params) async {
    screenNum = params.screenNumber;
    return await repository.getOnboardingInfo(screenNum);
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

  int total() {
    return ScreenNumber.end.index;
  }

  int current() {
    return screenNum.index;
  }
}

class Params extends Equatable {
  const Params({@required this.screenNumber});
  final ScreenNumber screenNumber;

  @override
  List<Object> get props => [screenNumber];
}
