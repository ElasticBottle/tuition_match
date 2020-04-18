import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/repositories/auth_service_repo.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ForgotPassword extends UseCase<void, ForgotPasswordParams> {
  ForgotPassword({this.repo});
  AuthServiceRepo repo;

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await repo.sendPasswordResetEmail(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({this.email});
  final String email;
  @override
  List<Object> get props => [email];
}
