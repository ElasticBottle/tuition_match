import 'package:cotor/domain/repositories/misc_repo.dart';
import 'package:flutter/foundation.dart';

class IsFirstAppLaunch {
  IsFirstAppLaunch({@required this.repo});
  final MiscRepo repo;
  bool call() {
    return repo.isFirstAppLaunch();
  }
}
