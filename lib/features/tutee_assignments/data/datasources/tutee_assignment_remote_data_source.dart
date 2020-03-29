import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';

abstract class TuteeAssignmentRemoteDataSource {
  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TuteeAssignmentModel> getAssignmentByCriterion({
    Level level,
    Subject subject,
    double rateMin,
    double rateMax,
  });

  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TuteeAssignmentModel> getAssignmentList();
}
