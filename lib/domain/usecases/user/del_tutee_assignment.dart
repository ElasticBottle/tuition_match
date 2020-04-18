import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DelTuteeAssignment extends UseCase<bool, DelTuteeAssignmentParams> {
  DelTuteeAssignment({this.repo});
  TuteeAssignmentRepo repo;
  @override
  Future<Either<Failure, bool>> call(DelTuteeAssignmentParams params) async {
    final Either<Failure, bool> success = await repo.delAssignment(
      postId: params.postId,
      uid: params.uid,
    );
    return success;
  }
}

class DelTuteeAssignmentParams extends Equatable {
  const DelTuteeAssignmentParams({this.postId, this.uid});

  final String postId;
  final String uid;

  @override
  List<Object> get props => [
        postId,
        uid,
      ];
}
