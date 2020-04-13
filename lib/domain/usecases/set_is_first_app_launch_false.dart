import 'package:cotor/domain/repositories/misc_repo.dart';
import 'package:flutter/foundation.dart';

class SetIsFirstAppLaunchFalse {
  SetIsFirstAppLaunchFalse({@required this.repo});
  final MiscRepo repo;
  Future<void> call() async {
    await repo.setFirstAppLaunchFalse();
  }
}
