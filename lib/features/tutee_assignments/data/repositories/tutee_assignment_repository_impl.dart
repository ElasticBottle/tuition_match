import 'package:cotor/core/platform/network_info.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_local_data_source.dart';
import 'package:cotor/features/tutee_assignments/data/datasources/tutee_assignment_remote_data_source.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/features/tutee_assignments/domain/repositories/tutee_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class TuteeAssignmentRepoImpl implements TuteeAssignmentRepo {
  TuteeAssignmentRepoImpl({this.remoteDs, this.localDs, this.networkInfo});
  final TuteeAssignmentRemoteDataSource remoteDs;
  final TuteeAssignmentLocalDataSource localDs;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getAssignmentList() {
    // TODO: implement getAssignmentList
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TuteeAssignment>>> getByCriterion(
      {Level level, Subject subject, double rateMin, double rateMax}) {
    // TODO: implement getByCriterion
    throw UnimplementedError();
  }
}
