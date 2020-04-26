import 'package:cotor/domain/repositories/tutee_assignment_repo.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:dartz/dartz.dart';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class RequestTutorProfile extends UseCase<bool, RequestTutorProfileParams> {
  RequestTutorProfile({
    this.userRepo,
  });
  final UserRepo userRepo;

  @override
  Future<Either<Failure, bool>> call(RequestTutorProfileParams params) async {
    return await userRepo.requestTutor(
      uid: params.requestingProfile.uid,
      assignment: params.assignment,
      isNewAssignment: params.isNewAssignment,
    );
  }
}

class RequestTutorProfileParams extends Equatable {
  const RequestTutorProfileParams({
    this.requestingProfile,
    this.assignment,
    this.isNewAssignment,
  });
  final TutorProfile requestingProfile;
  final TuteeAssignment assignment;
  final bool isNewAssignment;

  @override
  List<Object> get props => [
        requestingProfile,
        assignment,
        isNewAssignment,
      ];

  @override
  String toString() =>
      'RequestTutorProfileParams(requestingProfile: $requestingProfile, assignment: $assignment, isNewAssignment: $isNewAssignment)';
}
