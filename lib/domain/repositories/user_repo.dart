import 'dart:async';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepo {
  Future<Either<Failure, User>> getCurrentUser();
  void dispose();
}
