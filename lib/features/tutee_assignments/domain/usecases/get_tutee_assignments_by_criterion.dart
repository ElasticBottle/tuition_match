import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetTuteeAssignmentsByCriterion
    extends UseCase<List<TuteeAssignment>, CriteriaParams> {
  GetTuteeAssignmentsByCriterion({this.repo});

  TuteeAssignmentRepo repo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> call(params) async {
    final Either<Failure, List<TuteeAssignment>> result =
        await repo.getByCriterion(
      level: params.level,
      subject: params.subject,
      rateMin: params.rateMin,
      rateMax: params.rateMax,
    );
    return result;
  }
}

class CriteriaParams implements Params {
  const CriteriaParams({
    this.level = Level.all,
    this.subject = const Subject(
      level: Level.all,
      subjectArea: SubjectArea.ANY,
    ),
    this.rateMin = 0,
    this.rateMax = 999,
  });
  final Level level;
  final Subject subject;
  final double rateMin;
  final double rateMax;

  @override
  List<Object> get props => [
        level,
        subject,
        rateMin,
        rateMax,
      ];

  @override
  bool get stringify => false;
}
