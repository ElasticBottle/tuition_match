import 'package:cotor/core/error/exception.dart';
import 'package:cotor/features/onboarding/data/datasources/onboard_info_data_source.dart';
import 'package:cotor/features/onboarding/domain/entities/onboard_info.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:cotor/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryAdapter implements OnboardingRepository {
  const OnboardingRepositoryAdapter({this.dataSource});

  final OnboardInfoDataSource dataSource;
  @override
  Future<Either<Failure, OnboardInfo>> getOnboardingInfo(
      ScreenNumber number) async {
    try {
      final result = await dataSource.getOnbaordInfo(number);
      return Right<Failure, OnboardInfo>(result);
    } on FileException {
      return Left(FileFailure());
    }
  }
}
