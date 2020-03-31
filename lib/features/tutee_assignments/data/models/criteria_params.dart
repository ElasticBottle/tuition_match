import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';

class CriteriaParams extends Params {
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
}
