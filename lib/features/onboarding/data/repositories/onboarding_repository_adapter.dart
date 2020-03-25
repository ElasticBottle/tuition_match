import 'package:firebase_auth_demo_flutter/features/onboarding/data/datasources/onboard_info_data_source.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/entities/onboard_info.dart';
import 'package:firebase_auth_demo_flutter/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryAdapter implements OnboardingRepository {
  const OnboardingRepositoryAdapter({this.dataSource});

  final OnboardInfoDataSource dataSource;
  @override
  Future<Either<Failure, OnboardInfo>> getOnboardingInfo(ScreenNumber number) {
    // TODO: implement getOnboardingInfo
    throw UnimplementedError();
  }
}
