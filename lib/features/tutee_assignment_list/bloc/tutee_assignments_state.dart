part of 'tutee_assignments_bloc.dart';

abstract class AssignmentsState extends Equatable {
  const AssignmentsState();
}

class Loading extends AssignmentsState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'InitialAssignmentsState';
}

class AssignmentLoaded extends AssignmentsState {
  const AssignmentLoaded({
    this.assignments,
    this.isFetching,
    this.isEnd,
    this.isCachedList,
    this.isGetNextListError,
  });
  factory AssignmentLoaded.empty() {
    return AssignmentLoaded(
      assignments: const [],
      isFetching: false,
      isEnd: false,
      isCachedList: false,
      isGetNextListError: false,
    );
  }
  factory AssignmentLoaded.normal({List<TuteeAssignmentModel> assignments}) {
    return AssignmentLoaded(
      assignments: [...assignments],
      isFetching: false,
      isEnd: false,
      isCachedList: false,
      isGetNextListError: false,
    );
  }

  final List<TuteeAssignmentModel> assignments;
  final bool isFetching;
  final bool isEnd;
  final bool isCachedList;
  final bool isGetNextListError;

  AssignmentLoaded update({
    List<TuteeAssignmentModel> assignments,
    bool isFetching,
    bool isEnd,
    bool isCachedList,
  }) {
    return copyWith(
      assignments: assignments,
      isFetching: isFetching,
      isEnd: isEnd,
      isCachedList: isCachedList,
      isGetNextListError: false,
    );
  }

  AssignmentLoaded copyWith({
    List<TuteeAssignmentModel> assignments,
    bool isFetching,
    bool isEnd,
    bool isCachedList,
    bool isGetNextListError,
  }) {
    return AssignmentLoaded(
      assignments: assignments ?? [...this.assignments],
      isFetching: isFetching ?? this.isFetching,
      isEnd: isEnd ?? this.isEnd,
      isCachedList: isCachedList ?? this.isCachedList,
      isGetNextListError: isGetNextListError ?? this.isGetNextListError,
    );
  }

  @override
  List<Object> get props => [
        assignments,
        isFetching,
        isEnd,
      ];

  @override
  String toString() {
    return 'AssignmentLoaded(assignments: $assignments, isFetching: $isFetching, isEnd: $isEnd, isCachedList: $isCachedList, isGetNextListError: $isGetNextListError)';
  }
}

class InitialAssignmentsLoadError extends AssignmentsState {
  const InitialAssignmentsLoadError({
    @required this.message,
    @required this.isCacheError,
  });
  final String message;
  final bool isCacheError;

  @override
  List<Object> get props => [message];

  @override
  String toString() =>
      'AssignmentError(message: $message, isCacheError: $isCacheError)';
}
