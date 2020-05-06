import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DelTutorProfile extends UseCase<bool, DelTutorProfileParams> {
  DelTutorProfile({this.repo});
  final UserRepo repo;
  @override
  Future<Either<Failure, bool>> call(DelTutorProfileParams params) async {
    final Either<Failure, bool> success = await repo.delProfile(params.uid);
    return success;
  }
}

class DelTutorProfileParams extends Equatable {
  const DelTutorProfileParams({this.uid});

  final String uid;
  @override
  List<Object> get props => [uid];
}
