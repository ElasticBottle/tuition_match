import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetUserProfile extends UseCase<User, GetUserProfileParams> {
  GetUserProfile({this.repo});
  UserRepo repo;

  @override
  Future<Either<Failure, User>> call(GetUserProfileParams params) async {
    final result = await repo.getUserInfo(params.uid);
    return result;
  }
}

class GetUserProfileParams extends Equatable {
  const GetUserProfileParams({this.uid});
  final String uid;

  @override
  String toString() => 'UserParams { uid: $uid}';

  @override
  List<Object> get props => [uid];
}
