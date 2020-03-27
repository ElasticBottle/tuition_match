import 'package:cotor/core/error/exception.dart';
import 'package:cotor/features/onboarding/data/models/onboard_info_model.dart';
import 'package:cotor/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class OnboardInfoDataSource {
  Future<OnboardInfoModel> getOnbaordInfo(ScreenNumber number);
}

class OnboardInfoDataSourceImpl implements OnboardInfoDataSource {
  OnboardInfoDataSourceImpl(this.assetBundle);

  AssetBundle assetBundle;

  @override
  Future<OnboardInfoModel> getOnbaordInfo(ScreenNumber number) async {
    List<dynamic> result;

    switch (number) {
      case ScreenNumber.zero:
        result = await _retrieveDetailsAndImage(number.index.toString());
        break;
      case ScreenNumber.one:
        result = await _retrieveDetailsAndImage(number.index.toString());
        break;
      case ScreenNumber.two:
        result = await _retrieveDetailsAndImage(number.index.toString());
        break;
      case ScreenNumber.three:
        result = await _retrieveDetailsAndImage(number.index.toString());
        break;
      default:
        break;
    }
    return Future.value(
        OnboardInfoModel.fromStringAndImage(result[0], result[1]));
  }

  Future<List<dynamic>> _retrieveDetailsAndImage(String path) async {
    String details;
    AssetImage image;
    try {
      details = await assetBundle
          .loadString('assets/onboarding/texts/onboard' + path + '.txt');
      image = AssetImage('assets/onboarding/images/onboard' + path + '.png');
    } catch (e) {
      throw FileException();
    }
    return <dynamic>[details, image];
  }
}
