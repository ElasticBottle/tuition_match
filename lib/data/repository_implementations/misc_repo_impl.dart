import 'package:cotor/domain/repositories/misc_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String FIRST_APP_LAUNCH = 'FIRST_APP_LAUNCH';

class MiscRepoImpl implements MiscRepo {
  MiscRepoImpl({
    this.preferences,
  });
  final SharedPreferences preferences;

  @override
  bool isFirstAppLaunch() {
    final bool result = preferences.getBool(FIRST_APP_LAUNCH);
    if (result == null || result) {
      return true;
    }
    return false;
  }

  @override
  Future<void> setFirstAppLaunchFalse() async {
    return preferences.setBool(FIRST_APP_LAUNCH, false);
  }
}
