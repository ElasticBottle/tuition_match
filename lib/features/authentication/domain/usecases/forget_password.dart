import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/authentication/domain/repositories/authentication_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ForgotPassword extends UseCase<bool, ForgotPasswordParams> {
  ForgotPassword({this.repo});
  AuthenticationRepo repo;

  @override
  Future<Either<Failure, bool>> call(ForgotPasswordParams params) async {
    return await repo.sendPasswordResetEmail(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({this.email});
  final String email;
  @override
  List<Object> get props => [email];
}
