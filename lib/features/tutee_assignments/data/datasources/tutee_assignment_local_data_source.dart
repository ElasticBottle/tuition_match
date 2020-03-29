import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';

abstract class TuteeAssignmentLocalDataSource {
  /// Gets the cached [TuteeAssignmnetModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<List<TuteeAssignmentModel>> getLastAssignmentList();

  Future<void> cacheAssignmentList(
      List<TuteeAssignmentModel> assignmnetsToCache);
}
