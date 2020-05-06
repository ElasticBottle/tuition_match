import 'package:cotor/domain/entities/post/tutee_assignment/tutee_assignment.dart';
import 'package:cotor/domain/entities/post/tutor_profile/tutor_profile.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';

class RequestTutorProfile extends UseCase<bool, RequestTutorProfileParams> {
  RequestTutorProfile({
    this.userRepo,
  });
  final UserRepo userRepo;

  @override
  Future<Either<Failure, bool>> call(RequestTutorProfileParams params) async {
    return await userRepo.requestTutor(
      uid: params.requestingProfile.identity.uid,
      assignment: params.assignment,
      isNewAssignment: params.isNewAssignment,
      toSave: params.toSave,
    );
  }
}

class RequestTutorProfileParams extends Equatable {
  const RequestTutorProfileParams(
      {this.requestingProfile,
      this.assignment,
      this.isNewAssignment,
      this.toSave});
  final TutorProfile requestingProfile;
  final TuteeAssignment assignment;
  final bool isNewAssignment;
  final bool toSave;

  @override
  List<Object> get props => [
        requestingProfile,
        assignment,
        isNewAssignment,
        toSave,
      ];

  @override
  String toString() {
    return 'RequestTutorProfileParams(requestingProfile: $requestingProfile, assignment: $assignment, isNewAssignment: $isNewAssignment, toSave: $toSave)';
  }
}
