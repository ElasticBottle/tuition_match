import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class IsUserProfileCreated extends UseCase<bool, IsUserProfileCreatedParams> {
  IsUserProfileCreated({this.repo});
  final AuthenticationRepo repo;

  @override
  Future<Either<Failure, bool>> call(IsUserProfileCreatedParams params) async {
    final result = await repo.isUserProfileCreated(params.uid);
    return result;
  }
}

class IsUserProfileCreatedParams extends Equatable {
  const IsUserProfileCreatedParams({this.uid});
  final String uid;

  @override
  String toString() => 'UserParams { uid: $uid}';

  @override
  List<Object> get props => [uid];
}
