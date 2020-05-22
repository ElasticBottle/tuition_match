part of 'request_bloc.dart';

abstract class RequestState extends Equatable {
  Map<String, Map<String, Application>> get requests;
  String get id;
  bool get isLoadingProfile;
  bool get isLoadingAssignment;
  bool get isNewRequestAvailable;

  RequestState update({
    Map<String, Map<String, Application>> requests,
    String id,
    bool isLoadingProfile,
    bool isLoadingAssignment,
    bool isNewRequestAvailable,
  });
  RequestState copyWith({
    Map<String, Map<String, Application>> requests,
    String id,
    bool isLoadingProfile,
    bool isLoadingAssignment,
    bool isNewRequestAvailable,
  });
}

class RequestStateImpl implements RequestState {
  const RequestStateImpl({
    Map<String, Map<String, Application>> requests,
    String id,
    bool isLoadingProfile,
    bool isLoadingAssignment,
    bool isNewRequestAvailable,
  })  : _requests = requests,
        _id = id,
        _isLoadingAssignment = isLoadingAssignment,
        _isLoadingProfile = isLoadingProfile,
        _isNewRequestAvailable = isNewRequestAvailable;
  factory RequestStateImpl.initial() {
    return RequestStateImpl(
      requests: {},
      id: '',
      isLoadingAssignment: false,
      isLoadingProfile: false,
      isNewRequestAvailable: false,
    );
  }
  final Map<String, Map<String, Application>> _requests;
  final String _id;
  final bool _isLoadingProfile;
  final bool _isLoadingAssignment;
  final bool _isNewRequestAvailable;
  @override
  Map<String, Map<String, Application<PostBase, PostBase>>> get requests =>
      _requests;
  @override
  String get id => _id;
  @override
  bool get isLoadingProfile => _isLoadingProfile;
  @override
  bool get isLoadingAssignment => _isLoadingAssignment;
  @override
  bool get isNewRequestAvailable => _isNewRequestAvailable;

  @override
  RequestState update({
    Map<String, Map<String, Application>> requests,
    String id,
    bool isLoadingProfile,
    bool isLoadingAssignment,
    bool isNewRequestAvailable,
  }) {
    return copyWith(
      id: id,
      requests: requests,
      isLoadingAssignment: isLoadingAssignment ?? false,
      isLoadingProfile: isLoadingProfile ?? false,
      isNewRequestAvailable: isNewRequestAvailable ?? false,
    );
  }

  @override
  RequestState copyWith({
    Map<String, Map<String, Application>> requests,
    String id,
    bool isLoadingProfile,
    bool isLoadingAssignment,
    isNewRequestAvailable,
  }) {
    return RequestStateImpl(
      requests: requests ?? this.requests,
      id: id ?? this.id,
      isLoadingAssignment: isLoadingAssignment ?? this.isLoadingAssignment,
      isLoadingProfile: isLoadingProfile ?? this.isLoadingProfile,
      isNewRequestAvailable:
          isNewRequestAvailable ?? this.isNewRequestAvailable,
    );
  }

  @override
  List<Object> get props => [
        _requests,
        id,
        isLoadingProfile,
        isLoadingAssignment,
        isNewRequestAvailable
      ];
  @override
  bool get stringify => true;

  @override
  String toString() =>
      'RequestStateImpl(requests: $requests, id: $id, isLoadingProfile: $isLoadingProfile, isLoadingAssignment: $isLoadingAssignment,isNewRequestAvailable: $isNewRequestAvailable)';
}
