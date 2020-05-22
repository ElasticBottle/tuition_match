import 'package:cotor/domain/entities/post/applications/application.dart';
import 'package:cotor/domain/entities/post/base_post/post_base.dart';
import 'package:cotor/domain/repositories/user_repo.dart';
import 'package:equatable/equatable.dart';

class RequestStream {
  RequestStream({this.userRepo});
  final UserRepo userRepo;

  Stream<List<Application<PostBase, PostBase>>> call(
      RequestStreamParams params) {
    return userRepo.requestStream(id: params.id, isProfile: params.isProfile);
  }
}

class RequestStreamParams extends Equatable {
  const RequestStreamParams({this.id, this.isProfile});
  final String id;
  final bool isProfile;

  @override
  List<Object> get props => [id, isProfile];
}
