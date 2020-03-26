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
    String details;
    AssetImage image;
    switch (number) {
      case ScreenNumber.zero:
        try {
          details = await assetBundle.loadString('key');
          image = AssetImage('');
        } catch (e) {
          throw FileException();
        }
        break;
      case ScreenNumber.one:
        try {
          details = await assetBundle.loadString('key');
          image = AssetImage('');
        } catch (e) {
          throw FileException();
        }
        break;
      case ScreenNumber.two:
        try {
          details = await assetBundle.loadString('key');
          image = AssetImage('');
        } catch (e) {
          throw FileException();
        }
        break;
      case ScreenNumber.three:
        try {
          details = await assetBundle.loadString('key');
          image = AssetImage('');
        } catch (e) {
          throw FileException();
        }
        break;
      default:
        break;
    }
    return Future.value(OnboardInfoModel.fromStringAndImage(details, image));
  }
}
