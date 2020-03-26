import 'package:firebase_auth_demo_flutter/core/error/exception.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/data/models/onboard_info_model.dart';
import 'package:firebase_auth_demo_flutter/features/onboarding/domain/repositories/onboarding_repository.dart';
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
        result = await _retrieveDetailsAndImage('', '');
        break;
      case ScreenNumber.one:
        result = await _retrieveDetailsAndImage('', '');
        break;
      case ScreenNumber.two:
        result = await _retrieveDetailsAndImage('', '');
        break;
      case ScreenNumber.three:
        result = await _retrieveDetailsAndImage('', '');
        break;
      default:
        break;
    }
    return Future.value(
        OnboardInfoModel.fromStringAndImage(result[0], result[1]));
  }

  Future<List<dynamic>> _retrieveDetailsAndImage(
      String detailsPath, String imagePath) async {
    String details;
    AssetImage image;
    try {
      details = await assetBundle.loadString(detailsPath);
      image = AssetImage(imagePath);
    } catch (e) {
      throw FileException();
    }
    return <dynamic>[details, image];
  }
}
