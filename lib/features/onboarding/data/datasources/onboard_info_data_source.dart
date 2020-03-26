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
        details = await assetBundle.loadString('key');
        image = AssetImage('');
        break;
      case ScreenNumber.one:
        details = await assetBundle.loadString('key');
        image = AssetImage('');
        break;
      case ScreenNumber.two:
        details = await assetBundle.loadString('key');
        image = AssetImage('');
        break;
      case ScreenNumber.three:
        details = await assetBundle.loadString('key');
        image = AssetImage('');
        break;
      default:
        break;
    }
    return Future.value(OnboardInfoModel.fromStringAndImage(details, image));
  }
}
