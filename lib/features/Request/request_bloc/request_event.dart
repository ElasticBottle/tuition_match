part of 'request_bloc.dart';

abstract class RequestEvent extends Equatable {
  const RequestEvent();
  @override
  List<Object> get props => [];
}

class InitialiseRequestBloc extends RequestEvent {
  const InitialiseRequestBloc({this.uid});
  final String uid;

  @override
  List<Object> get props => [uid];
}

class RequestUserUpdated extends RequestEvent {
  const RequestUserUpdated(this.user);
  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'RequestUserUpdated(user: $user)';
}

class RequestForId extends RequestEvent {
  const RequestForId({this.id});
  final String id;
  @override
  List<Object> get props => [id];

  @override
  String toString() => 'RequestForId(id: $id)';
}

class RequestLoaded extends RequestEvent {
  const RequestLoaded({this.requests, this.id});
  final Map<String, Application> requests;
  final String id;

  @override
  List<Object> get props => [requests, id];

  @override
  String toString() => 'RequestLoaded(requests: $requests, id: $id)';
}

class RequestNewReqeustAvailable extends RequestEvent {}

class RequestLoadNewRequest extends RequestEvent {}

class RequestReviewd extends RequestEvent {}

class RequestAccept extends RequestEvent {}

class RequestDeclined extends RequestEvent {}
