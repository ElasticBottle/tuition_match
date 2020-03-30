import 'package:dartz/dartz.dart';

import 'network_info.dart';

class IsNetworkOnline<Failure, T> {
  Future<Either<Failure, T>> call(
      {NetworkInfo networkInfo, Failure ifOffline, Function ifOnline}) async {
    if (await networkInfo.isConnected) {
      return ifOnline();
    } else {
      return Left<Failure, T>(ifOffline);
    }
  }
}
