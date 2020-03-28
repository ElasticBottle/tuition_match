import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetTuteeAssignmentsByCriterion
    extends UseCase<List<TuteeAssignment>, Params> {
  GetTuteeAssignmentsByCriterion({this.repo});

  TuteeAssignmentRepo repo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> call(params) async {
    return await repo.getByCriterion(
      level: params.level,
      subject: params.subject,
      rateMin: params.rateMin,
      rateMax: params.rateMax,
    );
  }
}

class Params extends Equatable {
  const Params({
    this.level = Level.all,
    this.subject = Subject.all,
    this.rateMin = 0,
    this.rateMax = 999,
  });
  final Level level;
  final Subject subject;
  final int rateMin;
  final int rateMax;

  @override
  List<Object> get props => [];
}
